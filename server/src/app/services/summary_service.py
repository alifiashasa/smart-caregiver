"""
Weekly Summary Service business logic for periodic health summaries.

Responsibilities:
  1. Generate weekly health summaries for an elderly person
  2. Send summary notifications to caregiver
"""

from __future__ import annotations

import uuid
from datetime import datetime, timezone, timedelta
from typing import Optional, Sequence
from collections import defaultdict

from sqlalchemy import select, and_
from sqlalchemy.ext.asyncio import AsyncSession

from src.app.services.notification_service import create_notification
from src.database.enums import (
    HealthStatus,
    NotificationType,
    NotificationChannel,
    NotificationPriority,
)
from src.database.models.elderly import ElderlyProfile
from src.database.models.health import HealthRecord
from src.database.models.notification import Notification


def _calculate_weekly_summary(
    elderly_id: uuid.UUID,
    elderly_name: str,
    records: Sequence[HealthRecord],
    start_date: datetime,
    end_date: datetime,
) -> Optional[dict]:
    """Helper to calculate statistics given a list of records."""
    if not records:
        return None

    # Calculate statistics
    total_records = len(records)
    status_counts = {
        HealthStatus.NORMAL: 0,
        HealthStatus.WARNING: 0,
        HealthStatus.NEEDS_ATTENTION: 0,
        HealthStatus.CRITICAL: 0,
    }

    param_values = {
        "systolic_bp": [],
        "diastolic_bp": [],
        "blood_sugar": [],
        "heart_rate": [],
        "body_temperature": [],
        "spo2_level": [],
    }

    for record in records:
        # Status count
        status = record.health_status
        if status in status_counts:
            status_counts[status] += 1

        # Collect values for averages
        if record.systolic_bp is not None:
            param_values["systolic_bp"].append(record.systolic_bp)
        if record.diastolic_bp is not None:
            param_values["diastolic_bp"].append(record.diastolic_bp)
        if record.blood_sugar is not None:
            param_values["blood_sugar"].append(record.blood_sugar)
        if record.heart_rate is not None:
            param_values["heart_rate"].append(record.heart_rate)
        if record.body_temperature is not None:
            param_values["body_temperature"].append(record.body_temperature)
        if record.spo2_level is not None:
            param_values["spo2_level"].append(record.spo2_level)

    averages = {}
    for param, values in param_values.items():
        if values:
            averages[param] = sum(values) / len(values)
        else:
            averages[param] = None

    # Construct summary message body
    status_summary = "Records: {0}. ".format(total_records)
    alert_count = (
        status_counts[HealthStatus.WARNING]
        + status_counts[HealthStatus.NEEDS_ATTENTION]
        + status_counts[HealthStatus.CRITICAL]
    )
    status_summary += "Status: {0} Normal, {1} Alerts.".format(
        status_counts[HealthStatus.NORMAL], alert_count
    )

    return {
        "elderly_id": str(elderly_id),
        "elderly_name": elderly_name,
        "period_start": start_date.isoformat(),
        "period_end": end_date.isoformat(),
        "total_records": total_records,
        "status_counts": {k.value: v for k, v in status_counts.items()},
        "averages": averages,
        "body_summary": status_summary,
    }


async def generate_weekly_summary(
    db: AsyncSession,
    elderly_id: uuid.UUID,
) -> Optional[dict]:
    """
    Generate health summary for the last 7 days.

    Args:
        db: Database session
        elderly_id: UUID of the elderly profile

    Returns:
        Dictionary containing summary data or None if no records found
    """
    elderly_stmt = select(ElderlyProfile).where(ElderlyProfile.id == elderly_id)
    elderly_result = await db.execute(elderly_stmt)
    elderly = elderly_result.scalar_one_or_none()

    if not elderly:
        return None

    end_date = datetime.now(timezone.utc)
    start_date = end_date - timedelta(days=7)

    # Fetch health records for the last 7 days
    stmt = (
        select(HealthRecord)
        .where(
            and_(
                HealthRecord.elderly_id == elderly_id,
                HealthRecord.recorded_at >= start_date,
            )
        )
        .order_by(HealthRecord.recorded_at)
    )
    result = await db.execute(stmt)
    records = result.scalars().all()

    return _calculate_weekly_summary(
        elderly_id, elderly.full_name, records, start_date, end_date
    )


async def send_weekly_summary_notifications(
    db: AsyncSession,
    elderly_id: uuid.UUID,
) -> int:
    """
    Generate and send weekly summary notification to caregiver.

    Args:
        db: Database session
        elderly_id: UUID of the elderly profile

    Returns:
        Number of notifications sent
    """
    elderly_stmt = select(ElderlyProfile).where(ElderlyProfile.id == elderly_id)
    elderly_result = await db.execute(elderly_stmt)
    elderly = elderly_result.scalar_one_or_none()

    if not elderly:
        return 0

    end_date = datetime.now(timezone.utc)
    start_date = end_date - timedelta(days=7)

    stmt = (
        select(HealthRecord)
        .where(
            and_(
                HealthRecord.elderly_id == elderly_id,
                HealthRecord.recorded_at >= start_date,
            )
        )
        .order_by(HealthRecord.recorded_at)
    )
    result = await db.execute(stmt)
    records = result.scalars().all()

    summary = _calculate_weekly_summary(
        elderly_id, elderly.full_name, records, start_date, end_date
    )

    if not summary:
        return 0

    # Send to caregiver only
    recipient_ids = [elderly.caregiver_id]

    title = "Weekly Summary: {0}".format(elderly.full_name)
    body = "Here is the health summary for {0} from the past 7 days. {1}".format(
        elderly.full_name, summary["body_summary"]
    )

    sent_count = 0
    for recipient_id in recipient_ids:
        await create_notification(
            db=db,
            recipient_id=recipient_id,
            notification_type=NotificationType.WEEKLY_SUMMARY,
            title=title,
            body=body,
            elderly_id=elderly_id,
            payload={
                **summary,
                "elderly_id": str(elderly_id),
                "recipient_id": str(recipient_id),
            },
        )
        sent_count += 1

    await db.flush()
    return sent_count


async def process_all_weekly_summaries(db: AsyncSession) -> int:
    """
    Internal job to process weekly summaries for all active elderly profiles.
    Optimized to minimize database queries (N+1 issue fixed).
    """
    # 1. Fetch all active elderly profiles
    stmt = select(ElderlyProfile).where(ElderlyProfile.status == "active")
    result = await db.execute(stmt)
    elderly_profiles = result.scalars().all()

    if not elderly_profiles:
        return 0

    elderly_map = {e.id: e for e in elderly_profiles}
    elderly_ids = list(elderly_map.keys())

    end_date = datetime.now(timezone.utc)
    start_date = end_date - timedelta(days=7)

    # 2. Fetch all health records for these profiles in bulk
    records_stmt = select(HealthRecord).where(
        and_(
            HealthRecord.elderly_id.in_(elderly_ids),
            HealthRecord.recorded_at >= start_date,
        )
    )
    records_result = await db.execute(records_stmt)
    all_records = records_result.scalars().all()

    # Group records by elderly ID
    records_by_elderly = defaultdict(list)
    for record in all_records:
        records_by_elderly[record.elderly_id].append(record)

    # Sort them by recorded_at since we dropped the order_by in bulk query
    for eid in records_by_elderly:
        records_by_elderly[eid].sort(key=lambda x: x.recorded_at)

    notifications_to_create = []

    # 3. Process summaries and prepare notifications
    for eid, records in records_by_elderly.items():
        elderly = elderly_map[eid]
        summary = _calculate_weekly_summary(
            eid, elderly.full_name, records, start_date, end_date
        )

        if summary:
            recipient_id = elderly.caregiver_id
            title = "Weekly Summary: {0}".format(elderly.full_name)
            body = (
                "Here is the health summary for {0} from the past 7 days. {1}".format(
                    elderly.full_name, summary["body_summary"]
                )
            )

            notification = Notification(
                recipient_id=recipient_id,
                elderly_id=eid,
                notification_type=NotificationType.WEEKLY_SUMMARY,
                channel=NotificationChannel.IN_APP,
                title=title,
                body=body,
                payload={
                    **summary,
                    "elderly_id": str(eid),
                    "recipient_id": str(recipient_id),
                },
                priority=NotificationPriority.NORMAL,
            )
            notifications_to_create.append(notification)

    # 4. Bulk insert notifications
    if notifications_to_create:
        db.add_all(notifications_to_create)
        await db.flush()

    return len(notifications_to_create)
