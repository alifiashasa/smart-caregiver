"""Tests for FCM push notification service with mocked Firebase.

Key: firebase_admin, credentials, and messaging are imported INSIDE function
bodies (lazy imports), so patching must target the top-level module paths.
"""

import uuid
from unittest.mock import patch, AsyncMock, MagicMock

import pytest

from src.app.core.fcm_push import (
    _init_firebase_app,
    send_push_notification,
    send_to_user,
    send_to_users,
)
from src.app.core.config import settings


def teardown_function():
    """Reset _firebase_app state after each test."""
    import src.app.core.fcm_push as fcm
    fcm._firebase_app = None


@pytest.fixture
def mock_db():
    """Create a properly chained AsyncMock for db.execute()."""
    db = AsyncMock()
    # Set up execute to return a Result-like object
    exec_result = MagicMock()
    exec_result.scalars.return_value.all.return_value = []
    db.execute.return_value = exec_result
    return db


class TestInitFirebaseApp:
    def test_fcm_disabled_returns_false(self):
        settings.FCM_DISABLED = True
        result = _init_firebase_app()
        assert result is False

    def test_no_credentials_path_returns_false(self):
        settings.FCM_DISABLED = False
        settings.FCM_CREDENTIALS_PATH = ""
        result = _init_firebase_app()
        assert result is False

    @patch("firebase_admin.initialize_app")
    @patch("firebase_admin.credentials.Certificate")
    @patch("pathlib.Path.exists", return_value=True)
    def test_init_success(self, mock_exists, mock_cert, mock_init):
        settings.FCM_DISABLED = False
        settings.FCM_CREDENTIALS_PATH = "/fake/path/key.json"
        result = _init_firebase_app()
        assert result is True

    def test_already_initialized_returns_true(self):
        import src.app.core.fcm_push as fcm
        fcm._firebase_app = MagicMock()
        try:
            result = _init_firebase_app()
            assert result is True
        finally:
            fcm._firebase_app = None

    @patch("firebase_admin.initialize_app", side_effect=Exception("init failed"))
    @patch("firebase_admin.credentials.Certificate")
    @patch("pathlib.Path.exists", return_value=True)
    def test_init_failure_returns_false(self, mock_exists, mock_cert, mock_init):
        settings.FCM_DISABLED = False
        settings.FCM_CREDENTIALS_PATH = "/fake/path/key.json"
        result = _init_firebase_app()
        assert result is False


class TestSendPushNotification:
    @pytest.fixture(autouse=True)
    def _patch_android_priority(self):
        """Add AndroidPriority enum if missing (firebase-admin < 8.x compat)."""
        import firebase_admin.messaging as msg
        if not hasattr(msg, 'AndroidPriority'):
            msg.AndroidPriority = type('AndroidPriority', (), {
                'HIGH': 'high', 'NORMAL': 'normal',
            })

    @pytest.mark.asyncio
    @patch("src.app.core.fcm_push._init_firebase_app", return_value=False)
    async def test_fcm_disabled_returns_false(self, mock_init):
        result = await send_push_notification(
            fcm_token="token123", title="Test", body="Body"
        )
        assert result is False

    @pytest.mark.asyncio
    @patch("src.app.core.fcm_push._init_firebase_app", return_value=True)
    @patch("firebase_admin.messaging.send")
    async def test_send_success(self, mock_send, mock_init):
        mock_send.return_value = "projects/xxx/messages/yyy"
        result = await send_push_notification(
            fcm_token="token123",
            title="Test Title",
            body="Test Body",
            data={"key": "value"},
            priority="high",
        )
        assert result is True

    @pytest.mark.asyncio
    @patch("src.app.core.fcm_push._init_firebase_app", return_value=True)
    @patch("firebase_admin.messaging.send", side_effect=Exception("send failed"))
    async def test_send_failure_returns_false(self, mock_send, mock_init):
        result = await send_push_notification(
            fcm_token="token123", title="Test", body="Body"
        )
        assert result is False


class TestSendToUser:
    @pytest.mark.asyncio
    @patch("src.app.core.fcm_push._init_firebase_app", return_value=False)
    async def test_fcm_disabled_returns_zero(self, mock_init, mock_db):
        result = await send_to_user(mock_db, uuid.uuid4(), "Title", "Body")
        assert result == 0

    @pytest.mark.asyncio
    @patch("src.app.core.fcm_push._init_firebase_app", return_value=True)
    async def test_no_tokens_returns_zero(self, mock_init, mock_db):
        # No tokens = empty list from db query
        result = await send_to_user(mock_db, uuid.uuid4(), "Title", "Body")
        assert result == 0

    @pytest.mark.asyncio
    @patch("src.app.core.fcm_push._init_firebase_app", return_value=True)
    @patch("src.app.core.fcm_push.send_push_notification", new_callable=AsyncMock)
    async def test_sends_to_active_tokens(self, mock_send, mock_init, mock_db):
        # Set up mock_db to return 2 active tokens
        token1 = MagicMock()
        token1.fcm_token = "token1"
        token1.is_active = True
        token2 = MagicMock()
        token2.fcm_token = "token2"
        token2.is_active = True
        mock_db.execute.return_value.scalars.return_value.all.return_value = [token1, token2]

        mock_send.return_value = True
        result = await send_to_user(
            mock_db, uuid.uuid4(), "Title", "Body",
            data={"type": "test"}, priority="high",
        )
        assert result == 2
        assert mock_send.call_count == 2

    @pytest.mark.asyncio
    @patch("src.app.core.fcm_push._init_firebase_app", return_value=True)
    @patch("src.app.core.fcm_push.send_push_notification", new_callable=AsyncMock)
    async def test_invalid_token_deactivated(self, mock_send, mock_init, mock_db):
        token1 = MagicMock()
        token1.fcm_token = "token1"
        token1.is_active = True
        mock_db.execute.return_value.scalars.return_value.all.return_value = [token1]

        mock_send.side_effect = [True, False]
        result = await send_to_user(mock_db, uuid.uuid4(), "Title", "Body")
        assert result == 1


class TestSendToUsers:
    @pytest.mark.asyncio
    @patch("src.app.core.fcm_push.send_to_user", new_callable=AsyncMock, return_value=1)
    async def test_fan_out_multiple_users(self, mock_send_to_user, mock_db):
        user_ids = [uuid.uuid4(), uuid.uuid4(), uuid.uuid4()]
        result = await send_to_users(mock_db, user_ids, "Title", "Body")
        assert result == 3
        assert mock_send_to_user.call_count == 3

    @pytest.mark.asyncio
    @patch("src.app.core.fcm_push.send_to_user", new_callable=AsyncMock, return_value=0)
    async def test_empty_user_list(self, mock_send_to_user, mock_db):
        result = await send_to_users(mock_db, [], "Title", "Body")
        assert result == 0