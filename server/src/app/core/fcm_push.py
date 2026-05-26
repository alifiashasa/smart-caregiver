"""
FCM Push Notification Service.

Sends push notifications via Firebase Cloud Messaging (Firebase Admin SDK).

Usage:
    from src.app.core.fcm_push import fcm_push_service
    await fcm_push_service.send_to_user(user_id, title, body, data)

Requires:
    - firebase-admin Python package
    - Service account JSON key (FCM_CREDENTIALS_PATH in .env)
    - Device tokens registered via POST /notifications/register-device
"""

from __future__ import annotations

import json
import logging
from pathlib import Path
from typing import Optional

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from src.app.core.config import settings
from src.database.models.device_token import DeviceToken

logger = logging.getLogger(__name__)


# ---------------------------------------------------------------------------
# Lazy Firebase Admin SDK initialisation
# ---------------------------------------------------------------------------

_firebase_app = None


def _init_firebase_app() -> bool:
    """Initialise the Firebase Admin SDK once. Returns True if successful."""
    global _firebase_app
    if _firebase_app is not None:
        return True

    if settings.FCM_DISABLED:
        logger.info("FCM is disabled (FCM_DISABLED=true)")
        return False

    creds_path = settings.FCM_CREDENTIALS_PATH
    if not creds_path:
        logger.warning(
            "FCM_CREDENTIALS_PATH not set — push notifications disabled. "
            "Set FCM_CREDENTIALS_PATH in .env to enable."
        )
        return False

    try:
        import firebase_admin
        from firebase_admin import credentials

        cred_path = Path(creds_path)
        if not cred_path.exists():
            logger.error("FCM credentials file not found: %s", cred_path)
            return False

        cred = credentials.Certificate(str(cred_path))
        _firebase_app = firebase_admin.initialize_app(cred)
        logger.info("Firebase Admin SDK initialised successfully")
        return True
    except Exception as exc:
        logger.error("Failed to initialise Firebase Admin SDK: %s", exc)
        return False


# ---------------------------------------------------------------------------
# Push sending
# ---------------------------------------------------------------------------


async def send_push_notification(
    fcm_token: str,
    title: str,
    body: str,
    data: Optional[dict] = None,
    priority: str = "normal",
) -> bool:
    """Send a push notification to a single device token.

    Returns True if the message was accepted by FCM, False otherwise.
    """
    if not _init_firebase_app():
        return False

    try:
        from firebase_admin import messaging

        message = messaging.Message(
            notification=messaging.Notification(title=title, body=body),
            data={k: str(v) for k, v in (data or {}).items()},
            token=fcm_token,
            android=messaging.AndroidConfig(
                priority=(
                    messaging.AndroidPriority.HIGH
                    if priority == "high"
                    else messaging.AndroidPriority.NORMAL
                ),
            ),
        )
        response = messaging.send(message)
        logger.debug("FCM sent to token %s… — response: %s", fcm_token[:16], response)
        return True
    except Exception as exc:
        logger.warning("FCM send failed for token %s…: %s", fcm_token[:16], exc)
        return False


async def send_to_user(
    db: AsyncSession,
    user_id,
    title: str,
    body: str,
    data: Optional[dict] = None,
    priority: str = "normal",
) -> int:
    """Send push notification to all active device tokens for a user.

    Args:
        db: Database session
        user_id: UUID of the target user
        title: Push notification title
        body: Push notification body
        data: Optional custom data payload (becomes string→string dict)
        priority: "normal" or "high"

    Returns:
        Number of successful deliveries
    """
    if not _init_firebase_app():
        return 0

    stmt = select(DeviceToken).where(
        DeviceToken.user_id == user_id,
        DeviceToken.is_active == True,
    )
    result = await db.execute(stmt)
    tokens = result.scalars().all()

    if not tokens:
        logger.debug("No active device tokens for user %s", user_id)
        return 0

    success_count = 0
    for device_token in tokens:
        ok = await send_push_notification(
            fcm_token=device_token.fcm_token,
            title=title,
            body=body,
            data=data,
            priority=priority,
        )
        if ok:
            success_count += 1
        else:
            # If token is invalid, deactivate it
            device_token.is_active = False

    await db.flush()
    return success_count


async def send_to_users(
    db: AsyncSession,
    user_ids: list,
    title: str,
    body: str,
    data: Optional[dict] = None,
    priority: str = "normal",
) -> int:
    """Send push notification to multiple users (fan-out)."""
    total = 0
    for uid in user_ids:
        total += await send_to_user(
            db=db, user_id=uid, title=title, body=body, data=data, priority=priority
        )
    return total
