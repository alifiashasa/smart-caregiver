"""Unit tests for notification service edge cases."""

import uuid
from datetime import datetime, timezone, timedelta

import pytest
from sqlalchemy import select

from src.database.models.notification import Notification, NotificationPreference
from src.database.models.elderly import ElderlyProfile
from src.database.models.user import User
from src.database.enums import (
    NotificationType,
    NotificationChannel,
    NotificationPriority,
)
from src.app.services.notification_service import (
    create_notification,
    create_health_record_notification,
    get_notifications,
    get_unread_count,
    mark_as_read,
    mark_all_as_read,
    get_preferences,
    update_preference,
)
from src.app.schemas.notification import NotificationPreferenceUpdate


async def _make_user(db_session) -> User:
    uid = uuid.uuid4()
    user = User(
        id=uid,
        email=f"user_{uid.hex[:8]}@test.com",
        hashed_password="dummy",
        full_name="Test User",
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


class TestCreateNotification:
    @pytest.mark.asyncio
    async def test_create_basic_notification(self, db_session):
        user = await _make_user(db_session)
        notif = await create_notification(
            db=db_session,
            recipient_id=user.id,
            notification_type=NotificationType.HEALTH_RECORDED,
            title="Test Title",
            body="Test Body",
        )
        assert notif.recipient_id == user.id
        assert notif.notification_type == NotificationType.HEALTH_RECORDED
        assert notif.is_read is False
        assert notif.priority == NotificationPriority.NORMAL

    @pytest.mark.asyncio
    async def test_create_with_elderly_id(self, db_session):
        user = await _make_user(db_session)
        elderly = await _make_elderly(db_session, user.id)
        notif = await create_notification(
            db=db_session,
            recipient_id=user.id,
            notification_type=NotificationType.CRITICAL_ALERT,
            title="Alert",
            body="Critical alert",
            elderly_id=elderly.id,
            priority=NotificationPriority.HIGH,
        )
        assert notif.elderly_id == elderly.id
        assert notif.priority == NotificationPriority.HIGH

    @pytest.mark.asyncio
    async def test_create_with_payload(self, db_session):
        user = await _make_user(db_session)
        payload = {"key": "value", "numbers": [1, 2, 3]}
        notif = await create_notification(
            db=db_session,
            recipient_id=user.id,
            notification_type=NotificationType.WEEKLY_SUMMARY,
            title="Summary",
            body="Weekly summary",
            payload=payload,
        )
        assert notif.payload == payload


class TestCreateHealthRecordNotification:
    @pytest.mark.asyncio
    async def test_nonexistent_elderly_returns_empty(self, db_session):
        result = await create_health_record_notification(
            db=db_session,
            elderly_id=uuid.uuid4(),
            health_record_id=uuid.uuid4(),
            health_status="normal",
        )
        assert result == []

    @pytest.mark.asyncio
    async def test_normal_status_creates_health_recorded(self, db_session):
        user = await _make_user(db_session)
        elderly = await _make_elderly(db_session, user.id)
        health_record_id = uuid.uuid4()

        result = await create_health_record_notification(
            db=db_session,
            elderly_id=elderly.id,
            health_record_id=health_record_id,
            health_status="normal",
        )
        assert len(result) >= 1

        stmt = select(Notification).where(Notification.id == result[0])
        notif = (await db_session.execute(stmt)).scalar_one()
        assert notif.notification_type == NotificationType.HEALTH_RECORDED
        assert notif.priority == NotificationPriority.NORMAL

    @pytest.mark.asyncio
    async def test_critical_status_creates_critical_alert(self, db_session):
        user = await _make_user(db_session)
        elderly = await _make_elderly(db_session, user.id)

        result = await create_health_record_notification(
            db=db_session,
            elderly_id=elderly.id,
            health_record_id=uuid.uuid4(),
            health_status="critical",
            triggered_parameters=[{"parameter": "systolic_bp", "value": 180}],
        )
        assert len(result) >= 1

        stmt = select(Notification).where(Notification.id == result[0])
        notif = (await db_session.execute(stmt)).scalar_one()
        assert notif.notification_type == NotificationType.CRITICAL_ALERT
        assert notif.priority == NotificationPriority.HIGH
        assert notif.payload.get("triggered_parameters") is not None

    @pytest.mark.asyncio
    async def test_triggered_params_in_payload(self, db_session):
        user = await _make_user(db_session)
        elderly = await _make_elderly(db_session, user.id)
        params = [
            {"parameter": "systolic_bp", "value": 180},
            {"parameter": "heart_rate", "value": 130},
        ]
        result = await create_health_record_notification(
            db=db_session,
            elderly_id=elderly.id,
            health_record_id=uuid.uuid4(),
            health_status="warning",
            triggered_parameters=params,
        )
        stmt = select(Notification).where(Notification.id == result[0])
        notif = (await db_session.execute(stmt)).scalar_one()
        assert notif.payload["health_status"] == "warning"
        assert len(notif.payload["triggered_parameters"]) == 2


class TestGetNotifications:
    @pytest.mark.asyncio
    async def test_empty_list(self, db_session):
        user = await _make_user(db_session)
        total, notifs = await get_notifications(db_session, user.id)
        assert total == 0
        assert notifs == []

    @pytest.mark.asyncio
    async def test_pagination(self, db_session):
        user = await _make_user(db_session)
        for i in range(5):
            await create_notification(
                db=db_session,
                recipient_id=user.id,
                notification_type=NotificationType.HEALTH_RECORDED,
                title=f"Notif {i}",
                body=f"Body {i}",
            )
        await db_session.flush()

        total, notifs = await get_notifications(db_session, user.id, limit=2)
        assert total == 5
        assert len(notifs) == 2

    @pytest.mark.asyncio
    async def test_unread_only_filter(self, db_session):
        user = await _make_user(db_session)
        n1 = await create_notification(
            db=db_session,
            recipient_id=user.id,
            notification_type=NotificationType.HEALTH_RECORDED,
            title="Unread",
            body="Should appear",
        )
        await create_notification(
            db=db_session,
            recipient_id=user.id,
            notification_type=NotificationType.HEALTH_RECORDED,
            title="Read",
            body="Should not appear",
        )
        n1.is_read = True
        await db_session.flush()

        total, notifs = await get_notifications(
            db_session, user.id, unread_only=True
        )
        # At least one unread (the second one since n1 is read)
        # Note: notification ordering is desc by created_at
        assert total >= 1


class TestMarkAsRead:
    @pytest.mark.asyncio
    async def test_mark_not_found_raises(self, db_session):
        with pytest.raises(ValueError, match="Notification not found"):
            await mark_as_read(db_session, uuid.uuid4(), uuid.uuid4())

    @pytest.mark.asyncio
    async def test_mark_not_owned_raises(self, db_session):
        owner = await _make_user(db_session)
        other = await _make_user(db_session)
        notif = await create_notification(
            db=db_session,
            recipient_id=owner.id,
            notification_type=NotificationType.HEALTH_RECORDED,
            title="Test",
            body="Body",
        )
        with pytest.raises(ValueError, match="Not authorized"):
            await mark_as_read(db_session, notif.id, other.id)

    @pytest.mark.asyncio
    async def test_mark_success(self, db_session):
        user = await _make_user(db_session)
        notif = await create_notification(
            db=db_session,
            recipient_id=user.id,
            notification_type=NotificationType.HEALTH_RECORDED,
            title="Test",
            body="Body",
        )
        result = await mark_as_read(db_session, notif.id, user.id)
        assert result is True
        assert notif.is_read is True
        assert notif.read_at is not None

    @pytest.mark.asyncio
    async def test_mark_already_read(self, db_session):
        user = await _make_user(db_session)
        notif = await create_notification(
            db=db_session,
            recipient_id=user.id,
            notification_type=NotificationType.HEALTH_RECORDED,
            title="Test",
            body="Body",
        )
        notif.is_read = True
        notif.read_at = datetime.now(timezone.utc)
        await db_session.flush()

        result = await mark_as_read(db_session, notif.id, user.id)
        assert result is True


class TestMarkAllAsRead:
    @pytest.mark.asyncio
    async def test_no_unread_returns_zero(self, db_session):
        user = await _make_user(db_session)
        count = await mark_all_as_read(db_session, user.id)
        assert count == 0

    @pytest.mark.asyncio
    async def test_marks_all_unread(self, db_session):
        user = await _make_user(db_session)
        for i in range(3):
            await create_notification(
                db=db_session,
                recipient_id=user.id,
                notification_type=NotificationType.HEALTH_RECORDED,
                title=f"N{i}",
                body=f"B{i}",
            )
        await db_session.flush()

        count = await mark_all_as_read(db_session, user.id)
        assert count >= 3


class TestUnreadCount:
    @pytest.mark.asyncio
    async def test_zero_when_none(self, db_session):
        user = await _make_user(db_session)
        count = await get_unread_count(db_session, user.id)
        assert count == 0

    @pytest.mark.asyncio
    async def test_counts_only_unread(self, db_session):
        user = await _make_user(db_session)
        n1 = await create_notification(
            db=db_session,
            recipient_id=user.id,
            notification_type=NotificationType.HEALTH_RECORDED,
            title="N1",
            body="B1",
        )
        await create_notification(
            db=db_session,
            recipient_id=user.id,
            notification_type=NotificationType.HEALTH_RECORDED,
            title="N2",
            body="B2",
        )
        n1.is_read = True
        await db_session.flush()

        count = await get_unread_count(db_session, user.id)
        assert count == 1


class TestPreferences:
    @pytest.mark.asyncio
    async def test_get_empty_preferences(self, db_session):
        user = await _make_user(db_session)
        prefs = await get_preferences(db_session, user.id)
        assert prefs == []

    @pytest.mark.asyncio
    async def test_create_preference(self, db_session):
        user = await _make_user(db_session)
        payload = NotificationPreferenceUpdate(
            notification_type=NotificationType.HEALTH_RECORDED,
            email_enabled=True,
            push_enabled=False,
            in_app_enabled=True,
        )
        pref = await update_preference(db_session, user.id, payload)
        assert pref.user_id == user.id
        assert pref.notification_type == NotificationType.HEALTH_RECORDED
        assert pref.email_enabled is True
        assert pref.push_enabled is False

    @pytest.mark.asyncio
    async def test_update_existing_preference(self, db_session):
        user = await _make_user(db_session)
        # Create
        payload1 = NotificationPreferenceUpdate(
            notification_type=NotificationType.HEALTH_RECORDED,
            email_enabled=True,
            push_enabled=True,
            in_app_enabled=True,
        )
        await update_preference(db_session, user.id, payload1)

        # Update
        payload2 = NotificationPreferenceUpdate(
            notification_type=NotificationType.HEALTH_RECORDED,
            push_enabled=False,
        )
        pref = await update_preference(db_session, user.id, payload2)
        assert pref.push_enabled is False
        assert pref.email_enabled is True  # unchanged