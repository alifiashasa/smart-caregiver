"""
Notification Pydantic schemas.
REQ-019: Notify on new health record (caregiver)
REQ-020: Notify on critical status
"""

from datetime import datetime
from typing import Optional
from uuid import UUID

from pydantic import BaseModel, Field, ConfigDict

from src.database.enums import NotificationChannel, NotificationPriority, NotificationType


class NotificationResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: UUID
    recipient_id: UUID
    elderly_id: Optional[UUID] = None
    notification_type: NotificationType
    channel: NotificationChannel
    priority: NotificationPriority = NotificationPriority.NORMAL
    title: str
    body: str
    payload: Optional[dict] = None
    is_read: bool
    read_at: Optional[datetime] = None
    created_at: datetime


class NotificationList(BaseModel):
    total: int
    notifications: list[NotificationResponse]


class UnreadCountResponse(BaseModel):
    unread_count: int


class NotificationPreferenceResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: UUID
    user_id: UUID
    notification_type: NotificationType
    email_enabled: bool
    push_enabled: bool
    in_app_enabled: bool
    updated_at: datetime


class NotificationPreferenceUpdate(BaseModel):
    notification_type: NotificationType
    email_enabled: Optional[bool] = None
    push_enabled: Optional[bool] = None
    in_app_enabled: Optional[bool] = None


class NotificationPreferenceList(BaseModel):
    preferences: list[NotificationPreferenceResponse]


class MarkReadResponse(BaseModel):
    success: bool
    marked_count: int = 1


class DeviceTokenRegisterRequest(BaseModel):
    fcm_token: str = Field(..., min_length=1)
    platform: str = Field(default="android", pattern="^(android|ios)$")