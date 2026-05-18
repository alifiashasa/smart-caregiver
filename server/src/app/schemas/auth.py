"""
Auth Schemas for registration, login, and token responses.
"""

from datetime import datetime
from typing import Optional

import uuid
from pydantic import BaseModel, EmailStr, Field


class TokenResponse(BaseModel):
    """JWT token response."""

    access_token: str
    refresh_token: str
    token_type: str = "bearer"


class TokenRefreshRequest(BaseModel):
    """Request to refresh access token."""

    refresh_token: str


class LoginOtpResponse(BaseModel):
    """Response after registration starts email OTP challenge."""

    message: str
    email: EmailStr
    otp_expires_in_minutes: int


class VerifyOtpRequest(BaseModel):
    """Verify registration OTP sent to caregiver email."""

    email: EmailStr
    otp: str = Field(..., min_length=6, max_length=6, pattern=r"^\d{6}$")


class UserRegisterRequest(BaseModel):
    """User registration request."""

    email: EmailStr
    password: str = Field(..., min_length=8, max_length=100)
    full_name: str = Field(..., min_length=1, max_length=255)
    phone: Optional[str] = Field(None, max_length=20)


class UserLoginRequest(BaseModel):
    """User login request (email + password)."""

    email: EmailStr
    password: str


class UserResponse(BaseModel):
    """User public profile response."""

    id: uuid.UUID
    email: str
    full_name: str
    phone: Optional[str] = None
    avatar_url: Optional[str] = None
    is_email_verified: bool
    has_password: bool
    last_login_at: Optional[datetime] = None
    created_at: datetime

    model_config = {"from_attributes": True}


class UserMeResponse(BaseModel):
    """Current user profile response for /auth/me endpoint."""

    id: uuid.UUID
    email: str
    full_name: str
    phone: Optional[str] = None
    avatar_url: Optional[str] = None
    is_email_verified: bool
    has_password: bool
    last_login_at: Optional[datetime] = None
    created_at: datetime

    model_config = {"from_attributes": True}


class MessageResponse(BaseModel):
    """Simple message response."""

    message: str