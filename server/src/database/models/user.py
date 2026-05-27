"""
Auth & Onboarding models
REQ-001: email+password registration
"""

import uuid
from datetime import datetime
from typing import Optional

from sqlalchemy import (
    Boolean,
    DateTime,
    LargeBinary,
    String,
    func,
)
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from src.database.base import Base


class User(Base):
    """
    Core user table. All users are caregivers.
    Supports email/password authentication.
    """

    __tablename__ = "users"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    email: Mapped[str] = mapped_column(String(255), unique=True, nullable=False, index=True)
    full_name: Mapped[str] = mapped_column(String(255), nullable=False)
    phone: Mapped[Optional[str]] = mapped_column(String(20), nullable=True)

    # ── Password auth 
    hashed_password: Mapped[Optional[str]] = mapped_column(String(255), nullable=True)
    is_email_verified: Mapped[bool] = mapped_column(Boolean, default=False)
    email_verification_token: Mapped[Optional[str]] = mapped_column(String(255), nullable=True)
    email_verification_expires_at: Mapped[Optional[datetime]] = mapped_column(
        DateTime(timezone=True), nullable=True
    )

    # ── Password reset 
    password_reset_token: Mapped[Optional[str]] = mapped_column(String(255), nullable=True)
    password_reset_expires_at: Mapped[Optional[datetime]] = mapped_column(
        DateTime(timezone=True), nullable=True
    )

    # ── Account state 
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    avatar_url: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)

    # ── Face recognition (PRD REQ-001)
    # Pickled list[float] 512-dim InsightFace embedding.
    face_embedding: Mapped[Optional[bytes]] = mapped_column(LargeBinary, nullable=True)

    # ── Timestamps 
    last_login_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True), nullable=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), nullable=False
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False,
    )

    # ── Relationships 
    elderly_profiles: Mapped[list["ElderlyProfile"]] = relationship(
        back_populates="caregiver", cascade="all, delete-orphan", lazy="select"
    )
    notifications: Mapped[list["Notification"]] = relationship(
        back_populates="recipient", cascade="all, delete-orphan", lazy="select"
    )
    notification_preferences: Mapped[list["NotificationPreference"]] = relationship(
        back_populates="user", cascade="all, delete-orphan", lazy="selectin"
    )

    def __repr__(self) -> str:
        return f"<User id={self.id} email={self.email}>"

    @property
    def has_password(self) -> bool:
        """True if user can log in with email+password."""
        return self.hashed_password is not None
