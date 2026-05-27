"""
Google OAuth service for verifying ID tokens and linking users.

Uses Google's official `google-auth` library to verify the ID token
obtained from the Google Sign-In SDK on mobile clients.

Flow:
  1. Mobile app obtains id_token from Google Sign-In SDK
  2. Backend verifies id_token using google.oauth2.id_token.verify_oauth2_token
  3. Extract email, name, sub (google_id) from the verified token
  4. Find existing user by google_id or email, or create a new user
  5. Return the user
"""

from datetime import datetime, timezone
from typing import Any

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from google.auth.transport import requests as google_requests
from google.oauth2 import id_token as google_id_token

from src.app.core.config import settings
from src.app.core.security import create_access_token, create_refresh_token
from src.app.schemas.auth import TokenResponse
from src.database.models.user import User


async def verify_google_token(id_token: str) -> dict[str, Any]:
    """
    Verify a Google ID token and return the decoded payload.

    Args:
        id_token: The JWT id_token obtained from Google Sign-In SDK.

    Returns:
        Dictionary with keys: sub (google_id), email, name, picture, etc.

    Raises:
        ValueError: If the token is invalid, expired, or the audience
                    does not match our GOOGLE_CLIENT_ID.
    """
    try:
        request = google_requests.Request()
        info = google_id_token.verify_oauth2_token(
            id_token, request, settings.GOOGLE_CLIENT_ID
        )
    except ValueError as e:
        raise ValueError(f"Invalid Google token: {e}") from e

    # Ensure the token was issued by Google
    if info.get("iss") not in ("accounts.google.com", "https://accounts.google.com"):
        raise ValueError("Invalid token issuer — not issued by Google")

    return info


async def get_or_create_google_user(
    db: AsyncSession,
    google_data: dict[str, Any],
) -> User:
    """
    Retrieve an existing user linked to the Google account, or create a new one.

    Lookup order:
      1. Find user by google_id (sub claim).
      2. Find user by email (if email is verified by Google).
      3. If an existing user with the same email is found but has no google_id,
         link the google_id to that user.
      4. If no user is found, create a new user with google_id.

    Args:
        db: Database session.
        google_data: Verified token payload from Google containing
                     'sub' (google_id), 'email', 'name', 'picture', etc.

    Returns:
        The existing or newly created User.

    Raises:
        ValueError: If the Google email is not verified.
    """
    google_id = google_data.get("sub")
    email = google_data.get("email", "").lower()
    name = google_data.get("name", "")
    avatar_url = google_data.get("picture", "")
    email_verified = google_data.get("email_verified", False)

    if not google_id:
        raise ValueError("Google token missing 'sub' (google_id)")

    if not email:
        raise ValueError("Google token missing 'email'")

    if not email_verified:
        raise ValueError("Google email is not verified")

    # 1. Try to find existing user by google_id
    stmt = select(User).where(User.google_id == google_id)
    result = await db.execute(stmt)
    user = result.scalar_one_or_none()

    if user:
        # Update name and avatar if changed
        if name:
            user.full_name = name
        if avatar_url:
            user.avatar_url = avatar_url
        user.last_login_at = datetime.now(tz=timezone.utc)
        await db.flush()
        return user

    # 2. Try to find existing user by email
    stmt = select(User).where(User.email == email)
    result = await db.execute(stmt)
    user = result.scalar_one_or_none()

    if user:
        # Link google_id to existing user
        user.google_id = google_id
        if name:
            user.full_name = name
        if avatar_url:
            user.avatar_url = avatar_url
        if not user.is_email_verified:
            user.is_email_verified = True
        user.last_login_at = datetime.now(tz=timezone.utc)
        await db.flush()
        return user

    # 3. Create new user
    user = User(
        email=email,
        full_name=name or email.split("@")[0],
        google_id=google_id,
        avatar_url=avatar_url or None,
        is_email_verified=True,  # Google-verified email
        is_active=True,
        last_login_at=datetime.now(tz=timezone.utc),
    )
    db.add(user)
    await db.flush()
    return user


async def google_login(
    db: AsyncSession,
    id_token: str,
) -> TokenResponse:
    """
    Full Google OAuth login flow: verify token, get/create user, return JWT tokens.

    Args:
        db: Database session.
        id_token: The Google ID token from the mobile client.

    Returns:
        TokenResponse with access and refresh tokens.

    Raises:
        ValueError: If the Google token is invalid or user cannot be created.
    """
    google_data = await verify_google_token(id_token)
    user = await get_or_create_google_user(db, google_data)
    await db.flush()

    return TokenResponse(
        access_token=create_access_token(subject=str(user.id)),
        refresh_token=create_refresh_token(subject=str(user.id)),
        token_type="bearer",
    )
