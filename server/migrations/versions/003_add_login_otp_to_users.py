"""add_login_otp_to_users

Revision ID: 003_login_otp
Revises: 002_notification_priority
Create Date: 2026-05-14

"""
from __future__ import annotations

from alembic import op
import sqlalchemy as sa


revision = "003_login_otp"
down_revision = "002_notification_priority"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.add_column("users", sa.Column("login_otp_hash", sa.String(length=255), nullable=True))
    op.add_column(
        "users",
        sa.Column("login_otp_expires_at", sa.DateTime(timezone=True), nullable=True),
    )


def downgrade() -> None:
    op.drop_column("users", "login_otp_expires_at")
    op.drop_column("users", "login_otp_hash")
