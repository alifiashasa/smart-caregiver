"""Tests for recommendation approve→schedule side effect chain."""

import uuid
from datetime import datetime, timezone, timedelta

import pytest
from sqlalchemy import select

from src.database.models.elderly import ElderlyProfile
from src.database.models.recommendation import AIActivityRecommendation
from src.database.models.schedule import Schedule
from src.database.models.user import User
from src.database.enums import RecommendationStatus, ScheduleType
from src.app.services.recommendation_service import (
    approve_recommendation,
    reject_recommendation,
    get_recommendation,
    list_recommendations,
)


async def _make_user(db_session) -> User:
    uid = uuid.uuid4()
    user = User(
        id=uid,
        email=f"caregiver_{uid.hex[:8]}@test.com",
        hashed_password="dummy",
        full_name="Test Caregiver",
        is_active=True,
    )
    db_session.add(user)
    await db_session.flush()
    return user


async def _make_elderly(db_session, caregiver_id) -> ElderlyProfile:
    elderly = ElderlyProfile(
        id=uuid.uuid4(),
        caregiver_id=caregiver_id,
        full_name="Test Elderly",
        age=70,
        gender="male",
        mobility_level="assisted",
    )
    db_session.add(elderly)
    await db_session.flush()
    return elderly


async def _make_recommendation(
    db_session, elderly_id, status=RecommendationStatus.PENDING,
) -> AIActivityRecommendation:
    rec = AIActivityRecommendation(
        id=uuid.uuid4(),
        elderly_id=elderly_id,
        activity_name="Senam Pagi",
        category="physical",
        description="Senam ringan di pagi hari",
        duration_minutes=30,
        frequency_suggestion="3x per minggu",
        status=status,
    )
    db_session.add(rec)
    await db_session.flush()
    return rec


class TestApproveRecommendation:
    @pytest.mark.asyncio
    async def test_approve_nonexistent_raises(self, db_session):
        with pytest.raises(ValueError, match="not found"):
            await approve_recommendation(
                db=db_session,
                recommendation_id=uuid.uuid4(),
                approver_id=uuid.uuid4(),
            )

    @pytest.mark.asyncio
    async def test_approve_without_scheduled_at_no_schedule(self, db_session):
        user = await _make_user(db_session)
        elderly = await _make_elderly(db_session, user.id)
        rec = await _make_recommendation(db_session, elderly.id)

        result_rec, schedule_id = await approve_recommendation(
            db=db_session,
            recommendation_id=rec.id,
            approver_id=user.id,
        )
        assert result_rec.status == RecommendationStatus.APPROVED
        assert result_rec.approved_by == user.id
        assert schedule_id is None

    @pytest.mark.asyncio
    async def test_approve_with_scheduled_at_creates_schedule(self, db_session):
        user = await _make_user(db_session)
        elderly = await _make_elderly(db_session, user.id)
        rec = await _make_recommendation(db_session, elderly.id)
        future = datetime.now(timezone.utc) + timedelta(hours=24)

        result_rec, schedule_id = await approve_recommendation(
            db=db_session,
            recommendation_id=rec.id,
            approver_id=user.id,
            scheduled_at=future,
            duration_minutes=45,
            reminder_minutes=[15, 30],
        )
        assert result_rec.status == RecommendationStatus.APPROVED
        assert schedule_id is not None

        # Verify schedule was created
        stmt = select(Schedule).where(Schedule.id == schedule_id)
        sched = (await db_session.execute(stmt)).scalar_one()
        assert sched.title == rec.activity_name
        assert sched.elderly_id == elderly.id
        assert sched.schedule_type == ScheduleType.DAILY_ACTIVITY.value
        assert sched.source == "ai_approved"
        assert sched.ai_recommendation_id == rec.id
        assert sched.duration_minutes == 45
        assert len(sched.alarms) == 2

    @pytest.mark.asyncio
    async def test_approve_already_approved_raises(self, db_session):
        user = await _make_user(db_session)
        elderly = await _make_elderly(db_session, user.id)
        rec = await _make_recommendation(
            db_session, elderly.id, status=RecommendationStatus.APPROVED
        )

        with pytest.raises(ValueError, match="Cannot approve recommendation with status"):
            await approve_recommendation(
                db=db_session,
                recommendation_id=rec.id,
                approver_id=user.id,
            )

    @pytest.mark.asyncio
    async def test_approve_creates_schedule_with_default_duration(self, db_session):
        """When duration_minutes not provided, use recommendation's duration."""
        user = await _make_user(db_session)
        elderly = await _make_elderly(db_session, user.id)
        rec = await _make_recommendation(db_session, elderly.id)
        future = datetime.now(timezone.utc) + timedelta(hours=8)

        result_rec, schedule_id = await approve_recommendation(
            db=db_session,
            recommendation_id=rec.id,
            approver_id=user.id,
            scheduled_at=future,
        )
        sched = (await db_session.execute(
            select(Schedule).where(Schedule.id == schedule_id)
        )).scalar_one()
        assert sched.duration_minutes == rec.duration_minutes  # 30


class TestRejectRecommendation:
    @pytest.mark.asyncio
    async def test_reject_success(self, db_session):
        user = await _make_user(db_session)
        elderly = await _make_elderly(db_session, user.id)
        rec = await _make_recommendation(db_session, elderly.id)

        result = await reject_recommendation(
            db=db_session,
            recommendation_id=rec.id,
            approver_id=user.id,
            reason="Not appropriate at this time",
        )
        assert result.status == RecommendationStatus.REJECTED
        assert result.rejection_reason == "Not appropriate at this time"

    @pytest.mark.asyncio
    async def test_reject_nonexistent_raises(self, db_session):
        with pytest.raises(ValueError, match="not found"):
            await reject_recommendation(
                db=db_session,
                recommendation_id=uuid.uuid4(),
                approver_id=uuid.uuid4(),
            )

    @pytest.mark.asyncio
    async def test_reject_already_approved_raises(self, db_session):
        user = await _make_user(db_session)
        elderly = await _make_elderly(db_session, user.id)
        rec = await _make_recommendation(
            db_session, elderly.id, status=RecommendationStatus.APPROVED
        )

        with pytest.raises(ValueError, match="Cannot reject recommendation with status"):
            await reject_recommendation(
                db=db_session,
                recommendation_id=rec.id,
                approver_id=user.id,
            )

    @pytest.mark.asyncio
    async def test_reject_without_reason(self, db_session):
        user = await _make_user(db_session)
        elderly = await _make_elderly(db_session, user.id)
        rec = await _make_recommendation(db_session, elderly.id)

        result = await reject_recommendation(
            db=db_session,
            recommendation_id=rec.id,
            approver_id=user.id,
        )
        assert result.status == RecommendationStatus.REJECTED
        assert result.rejection_reason is None


class TestGetRecommendation:
    @pytest.mark.asyncio
    async def test_get_nonexistent(self, db_session):
        result = await get_recommendation(db_session, uuid.uuid4())
        assert result is None

    @pytest.mark.asyncio
    async def test_get_existing(self, db_session):
        user = await _make_user(db_session)
        elderly = await _make_elderly(db_session, user.id)
        rec = await _make_recommendation(db_session, elderly.id)

        result = await get_recommendation(db_session, rec.id)
        assert result.id == rec.id
        assert result.activity_name == "Senam Pagi"


class TestListRecommendations:
    @pytest.mark.asyncio
    async def test_empty(self, db_session):
        total, recs = await list_recommendations(
            db_session, elderly_id=uuid.uuid4()
        )
        assert total == 0
        assert recs == []

    @pytest.mark.asyncio
    async def test_status_filter(self, db_session):
        user = await _make_user(db_session)
        elderly = await _make_elderly(db_session, user.id)
        rec1 = await _make_recommendation(db_session, elderly.id)  # PENDING
        rec2 = await _make_recommendation(
            db_session, elderly.id, status=RecommendationStatus.APPROVED
        )

        # Should find only PENDING
        total, recs = await list_recommendations(
            db_session, elderly.id, status=RecommendationStatus.PENDING
        )
        assert total >= 1
        for r in recs:
            assert r.status == RecommendationStatus.PENDING