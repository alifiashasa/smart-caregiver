"""
Authentication service for email/password registration and login.

This service handles:
- User registration with email + password
- User login verification
- Token refresh
"""

import secrets
from datetime import datetime, timedelta, timezone
from typing import Optional

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from src.app.core.config import settings
from src.app.core.security import (
    create_access_token,
    create_refresh_token,
    decode_token,
    hash_password,
    verify_password,
)
from src.app.schemas.auth import (
    LoginOtpResponse,
    TokenResponse,
    UserLoginRequest,
    UserRegisterRequest,
    VerifyOtpRequest,
)
from src.app.services.resend_service import send_login_otp_email
from src.database.models.user import User


async def register_user(
    db: AsyncSession,
    payload: UserRegisterRequest,
) -> tuple[User, TokenResponse]:
    """
    Register a new user with email + password.

    Kept for internal compatibility. Register endpoint uses OTP flow.
    Raises ValueError if email already exists.
    """
    user = await _create_password_user(db=db, payload=payload)
    return user, _create_token_response(user)


async def register_user_with_otp(
    db: AsyncSession,
    payload: UserRegisterRequest,
) -> tuple[User, LoginOtpResponse]:
    """
    Register caregiver, generate OTP, and send it to caregiver email.

    Raises ValueError if email already exists.
    Raises RuntimeError if OTP email cannot be sent.
    """
    user = await _create_password_user(db=db, payload=payload)
    otp_response = await _set_and_send_login_otp(user=user)
    await db.flush()
    return user, otp_response


async def start_login_otp(
    db: AsyncSession,
    payload: UserLoginRequest,
) -> tuple[User, LoginOtpResponse]:
    """
    Authenticate email/password, generate OTP, and send it to caregiver email.

    Raises ValueError if credentials invalid.
    Raises RuntimeError if OTP email cannot be sent.
    """
    user = await _get_authenticated_password_user(db=db, payload=payload)
    otp_response = await _set_and_send_login_otp(user=user)
    await db.flush()

    return user, otp_response


async def verify_login_otp(
    db: AsyncSession,
    payload: VerifyOtpRequest,
) -> tuple[User, TokenResponse]:
    """
    Verify login OTP and issue JWT tokens.

    Raises ValueError if OTP is invalid or expired.
    """
    email = payload.email.lower()
    stmt = select(User).where(User.email == email)
    result = await db.execute(stmt)
    user = result.scalar_one_or_none()

    if user is None or not user.is_active:
        raise ValueError("Invalid or expired OTP")

    if not user.login_otp_hash or not user.login_otp_expires_at:
        raise ValueError("Invalid or expired OTP")

    expires_at = _as_aware_utc(user.login_otp_expires_at)
    if expires_at <= datetime.now(tz=timezone.utc):
        user.login_otp_hash = None
        user.login_otp_expires_at = None
        await db.flush()
        raise ValueError("Invalid or expired OTP")

    try:
        otp_matches = verify_password(payload.otp, user.login_otp_hash)
    except ValueError:
        otp_matches = False

    if not otp_matches:
        raise ValueError("Invalid or expired OTP")

    user.login_otp_hash = None
    user.login_otp_expires_at = None
    user.is_email_verified = True
    user.last_login_at = datetime.now(tz=timezone.utc)
    await db.flush()

    return user, _create_token_response(user)


async def authenticate_user(
    db: AsyncSession,
    payload: UserLoginRequest,
) -> tuple[User, TokenResponse]:
    """
    Authenticate user with email/password and issue tokens.

    Kept for internal compatibility. Password login endpoints use OTP flow.
    """
    user = await _get_authenticated_password_user(db=db, payload=payload)
    user.last_login_at = datetime.now(tz=timezone.utc)
    await db.flush()
    return user, _create_token_response(user)


async def refresh_access_token(
    db: AsyncSession,
    refresh_token: str,
) -> TokenResponse:
    """
    Refresh access token using refresh token.
    
    Raises ValueError if refresh token invalid.
    """
    payload = decode_token(refresh_token)
    
    if payload is None or payload.get("type") != "refresh":
        raise ValueError("Invalid or expired refresh token")

    user_id = payload.get("sub")
    if user_id is None:
        raise ValueError("Invalid token payload")

    stmt = select(User).where(User.id == user_id)
    result = await db.execute(stmt)
    user = result.scalar_one_or_none()

    if user is None or not user.is_active:
        raise ValueError("User not found or inactive")

    return _create_token_response(user)


async def _create_password_user(
    db: AsyncSession,
    payload: UserRegisterRequest,
) -> User:
    """Create caregiver with email/password credentials."""
    email = payload.email.lower()

    existing_stmt = select(User).where(User.email == email)
    existing = await db.execute(existing_stmt)
    if existing.scalar_one_or_none():
        raise ValueError("Email already registered")

    user = User(
        email=email,
        full_name=payload.full_name,
        phone=payload.phone,
        hashed_password=hash_password(payload.password),
        is_email_verified=False,
    )
    db.add(user)
    await db.flush()
    return user


async def _get_authenticated_password_user(
    db: AsyncSession,
    payload: UserLoginRequest,
) -> User:
    """Validate email/password credentials and return active user."""
    email = payload.email.lower()

    stmt = select(User).where(User.email == email)
    result = await db.execute(stmt)
    user = result.scalar_one_or_none()

    if user is None:
        raise ValueError("Invalid email or password")

    if not user.hashed_password or not verify_password(payload.password, user.hashed_password):
        raise ValueError("Invalid email or password")

    if not user.is_active:
        raise ValueError("User account is inactive")

    return user


async def _set_and_send_login_otp(user: User) -> LoginOtpResponse:
    """Set hashed OTP on user and send raw code to caregiver email."""
    otp_code = _generate_otp_code()
    expires_in_minutes = settings.LOGIN_OTP_EXPIRE_MINUTES

    user.login_otp_hash = hash_password(otp_code)
    user.login_otp_expires_at = datetime.now(tz=timezone.utc) + timedelta(
        minutes=expires_in_minutes
    )

    await send_login_otp_email(
        to_email=user.email,
        otp_code=otp_code,
        expires_in_minutes=expires_in_minutes,
    )

    return LoginOtpResponse(
        message="OTP sent to caregiver email",
        email=user.email,
        otp_expires_in_minutes=expires_in_minutes,
    )


def _generate_otp_code() -> str:
    """Generate 6-digit numeric OTP."""
    return f"{secrets.randbelow(1_000_000):06d}"


def _as_aware_utc(value: datetime) -> datetime:
    """Normalize naive DB datetimes as UTC."""
    if value.tzinfo is None:
        return value.replace(tzinfo=timezone.utc)
    return value.astimezone(timezone.utc)


def _create_token_response(user: User) -> TokenResponse:
    """Create token response for user."""
    return TokenResponse(
        access_token=create_access_token(subject=str(user.id)),
        refresh_token=create_refresh_token(subject=str(user.id)),
        token_type="bearer",
    )


async def get_user_by_id(
    db: AsyncSession,
    user_id: str,
) -> Optional[User]:
    """Get user by ID."""
    stmt = select(User).where(User.id == user_id)
    result = await db.execute(stmt)
    return result.scalar_one_or_none()