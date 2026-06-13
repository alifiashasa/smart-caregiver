"""
Operational super admin router for the lightweight Vite web-admin.

The web-admin intentionally avoids exposing caregiver medical data. It focuses
on application monitoring, app announcements, and minimal caregiver account
administration.
"""

from __future__ import annotations

import uuid
from datetime import datetime, timedelta, timezone
from html import escape
from typing import Literal

from fastapi import APIRouter, Depends, HTTPException, Query, Request, status
from pydantic import BaseModel, EmailStr, Field
from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from src.app.core.config import settings
from src.app.core.security import hash_password
from src.app.services.resend_service import send_email
from src.database.enums import ElderlyStatus, HealthStatus, NotificationChannel, NotificationPriority, NotificationType
from src.database.models.elderly import ElderlyProfile
from src.database.models.health import HealthRecord
from src.database.models.notification import Notification
from src.database.models.user import User
from src.database.session import get_db

router = APIRouter(prefix="/admin", tags=["admin"])

ActiveFilter = Literal["all", "active", "inactive"]
VerifiedFilter = Literal["all", "verified", "unverified"]
AnnouncementChannel = Literal["in_app", "email"]


class CaregiverCreate(BaseModel):
    email: EmailStr
    password: str = Field(..., min_length=8, max_length=100)
    full_name: str = Field(..., min_length=1, max_length=255)
    phone: str | None = Field(default=None, max_length=20)
    is_email_verified: bool = True


class CaregiverStatusUpdate(BaseModel):
    is_active: bool


class AnnouncementTarget(BaseModel):
    active: ActiveFilter = "active"
    verified: VerifiedFilter = "all"


class AnnouncementPreviewRequest(BaseModel):
    target: AnnouncementTarget


class AnnouncementCreate(BaseModel):
    title: str = Field(..., min_length=3, max_length=120)
    body: str = Field(..., min_length=5, max_length=1200)
    target: AnnouncementTarget
    channels: list[AnnouncementChannel] = Field(default_factory=lambda: ["in_app"])


async def verify_admin_api_key(request: Request) -> None:
    api_key = settings.INTERNAL_API_KEY
    if not api_key:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="INTERNAL_API_KEY belum dikonfigurasi untuk web-admin.",
        )

    provided = request.headers.get("X-API-Key")
    if not provided or provided != api_key:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Invalid or missing admin API key",
        )


async def scalar_count(db: AsyncSession, stmt) -> int:
    result = await db.execute(stmt)
    return int(result.scalar_one() or 0)


def to_iso(value: datetime | None) -> str | None:
    if value is None:
        return None
    return value.isoformat()


def apply_user_filters(stmt, target: AnnouncementTarget):
    if target.active == "active":
        stmt = stmt.where(User.is_active.is_(True))
    elif target.active == "inactive":
        stmt = stmt.where(User.is_active.is_(False))

    if target.verified == "verified":
        stmt = stmt.where(User.is_email_verified.is_(True))
    elif target.verified == "unverified":
        stmt = stmt.where(User.is_email_verified.is_(False))

    return stmt


async def get_target_users(db: AsyncSession, target: AnnouncementTarget) -> list[User]:
    stmt = apply_user_filters(select(User).order_by(User.created_at.desc()), target)
    result = await db.execute(stmt)
    return list(result.scalars().all())


@router.get("/operations", dependencies=[Depends(verify_admin_api_key)])
async def get_operations_summary(db: AsyncSession = Depends(get_db)):
    now = datetime.now(timezone.utc)
    week_start = now - timedelta(days=7)

    total_caregivers = await scalar_count(db, select(func.count()).select_from(User))
    active_caregivers = await scalar_count(
        db, select(func.count()).select_from(User).where(User.is_active.is_(True))
    )
    inactive_caregivers = await scalar_count(
        db, select(func.count()).select_from(User).where(User.is_active.is_(False))
    )
    verified_caregivers = await scalar_count(
        db, select(func.count()).select_from(User).where(User.is_email_verified.is_(True))
    )
    unverified_caregivers = await scalar_count(
        db, select(func.count()).select_from(User).where(User.is_email_verified.is_(False))
    )
    new_caregivers_week = await scalar_count(
        db, select(func.count()).select_from(User).where(User.created_at >= week_start)
    )

    critical_elderly = await scalar_count(
        db,
        select(func.count()).select_from(ElderlyProfile).where(
            ElderlyProfile.status == ElderlyStatus.CRITICAL
        ),
    )
    warning_or_critical_records = await scalar_count(
        db,
        select(func.count()).select_from(HealthRecord).where(
            HealthRecord.health_status.in_([HealthStatus.WARNING, HealthStatus.NEEDS_ATTENTION, HealthStatus.CRITICAL])
        ),
    )
    health_records_week = await scalar_count(
        db,
        select(func.count()).select_from(HealthRecord).where(HealthRecord.recorded_at >= week_start),
    )

    return {
        "system": {
            "api": "healthy",
            "database": "reachable",
            "email_configured": bool(settings.RESEND_API_KEY),
            "generated_at": to_iso(now),
        },
        "caregivers": {
            "total": total_caregivers,
            "active": active_caregivers,
            "inactive": inactive_caregivers,
            "verified": verified_caregivers,
            "unverified": unverified_caregivers,
            "new_last_7_days": new_caregivers_week,
        },
        "sensitive_aggregate": {
            "elderly_total": await scalar_count(db, select(func.count()).select_from(ElderlyProfile)),
            "elderly_critical": critical_elderly,
            "health_records_total": await scalar_count(db, select(func.count()).select_from(HealthRecord)),
            "health_records_last_7_days": health_records_week,
            "warning_or_critical_records": warning_or_critical_records,
        },
    }


@router.post("/announcements/preview", dependencies=[Depends(verify_admin_api_key)])
async def preview_announcement_recipients(
    payload: AnnouncementPreviewRequest,
    db: AsyncSession = Depends(get_db),
):
    stmt = apply_user_filters(select(func.count()).select_from(User), payload.target)
    return {"recipient_count": await scalar_count(db, stmt)}


@router.post(
    "/announcements",
    status_code=status.HTTP_201_CREATED,
    dependencies=[Depends(verify_admin_api_key)],
)
async def create_announcement(
    payload: AnnouncementCreate,
    db: AsyncSession = Depends(get_db),
):
    channels = set(payload.channels)
    if not channels:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Pilih minimal satu channel pengumuman.",
        )

    recipients = await get_target_users(db, payload.target)
    announcement_id = str(uuid.uuid4())
    created_at = datetime.now(timezone.utc)
    email_sent = 0
    email_failed = 0

    for recipient in recipients:
        if "in_app" in channels:
            db.add(
                Notification(
                    recipient_id=recipient.id,
                    notification_type=NotificationType.APP_ANNOUNCEMENT,
                    channel=NotificationChannel.IN_APP,
                    priority=NotificationPriority.NORMAL,
                    title=payload.title,
                    body=payload.body,
                    payload={
                        "announcement_id": announcement_id,
                        "target": payload.target.model_dump(),
                        "channels": sorted(channels),
                    },
                )
            )

        if "email" in channels:
            try:
                await send_email(
                    to_email=recipient.email,
                    subject=payload.title,
                    text=payload.body,
                    html=f"""
                    <div style="font-family: Arial, sans-serif; line-height: 1.6; color: #111827;">
                      <h2>{escape(payload.title)}</h2>
                      <p>{escape(payload.body)}</p>
                      <p style="color: #6b7280; font-size: 12px;">Smart Caregiver</p>
                    </div>
                    """,
                )
                email_sent += 1
            except RuntimeError:
                email_failed += 1

    await db.commit()

    return {
        "announcement_id": announcement_id,
        "recipient_count": len(recipients),
        "in_app_created": len(recipients) if "in_app" in channels else 0,
        "email_sent": email_sent,
        "email_failed": email_failed,
        "created_at": to_iso(created_at),
    }


@router.get("/announcements", dependencies=[Depends(verify_admin_api_key)])
async def list_announcements(
    limit: int = Query(default=10, ge=1, le=50),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(Notification)
        .where(Notification.notification_type == NotificationType.APP_ANNOUNCEMENT)
        .order_by(Notification.created_at.desc())
        .limit(500)
    )

    grouped = {}
    for notification in result.scalars().all():
        payload = notification.payload or {}
        announcement_id = payload.get("announcement_id", str(notification.id))
        item = grouped.setdefault(
            announcement_id,
            {
                "announcement_id": announcement_id,
                "title": notification.title,
                "target": payload.get("target", {}),
                "channels": payload.get("channels", [str(notification.channel)]),
                "recipient_count": 0,
                "created_at": to_iso(notification.created_at),
            },
        )
        item["recipient_count"] += 1

    return {"items": list(grouped.values())[:limit]}


@router.post("/caregivers", status_code=status.HTTP_201_CREATED, dependencies=[Depends(verify_admin_api_key)])
async def create_caregiver(
    payload: CaregiverCreate,
    db: AsyncSession = Depends(get_db),
):
    email = payload.email.lower()
    existing_result = await db.execute(select(User).where(User.email == email))
    if existing_result.scalar_one_or_none() is not None:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Email caregiver sudah terdaftar",
        )

    user = User(
        email=email,
        full_name=payload.full_name,
        phone=payload.phone,
        hashed_password=hash_password(payload.password),
        is_email_verified=payload.is_email_verified,
        is_active=True,
    )
    db.add(user)
    await db.commit()
    await db.refresh(user)

    return {
        "id": str(user.id),
        "email": user.email,
        "full_name": user.full_name,
        "phone": user.phone,
        "is_active": user.is_active,
        "is_email_verified": user.is_email_verified,
        "created_at": to_iso(user.created_at),
    }


@router.get("/caregivers", dependencies=[Depends(verify_admin_api_key)])
async def list_caregivers(
    limit: int = Query(default=20, ge=1, le=100),
    offset: int = Query(default=0, ge=0),
    db: AsyncSession = Depends(get_db),
):
    total = await scalar_count(db, select(func.count()).select_from(User))
    result = await db.execute(
        select(User).order_by(User.created_at.desc()).limit(limit).offset(offset)
    )

    return {
        "total": total,
        "items": [
            {
                "id": str(user.id),
                "email": user.email,
                "full_name": user.full_name,
                "phone": user.phone,
                "is_active": user.is_active,
                "is_email_verified": user.is_email_verified,
                "created_at": to_iso(user.created_at),
            }
            for user in result.scalars().all()
        ],
    }


@router.patch("/caregivers/{user_id}/status", dependencies=[Depends(verify_admin_api_key)])
async def update_caregiver_status(
    user_id: uuid.UUID,
    payload: CaregiverStatusUpdate,
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalar_one_or_none()
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Caregiver tidak ditemukan",
        )

    user.is_active = payload.is_active
    await db.commit()
    await db.refresh(user)
    return {
        "id": str(user.id),
        "email": user.email,
        "full_name": user.full_name,
        "is_active": user.is_active,
    }
