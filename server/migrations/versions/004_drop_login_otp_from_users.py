"""drop_login_otp_from_users

Revision ID: 004_drop_login_otp
Revises: 003_login_otp
Create Date: 2026-05-15

"""
from __future__ import annotations

from alembic import op
import sqlalchemy as sa


revision = "004_drop_login_otp"
down_revision = "003_login_otp"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.drop_column("users", "login_otp_expires_at")
    op.drop_column("users", "login_otp_hash")


def downgrade() -> None:
    op.add_column("users", sa.Column("login_otp_hash", sa.String(length=255), nullable=True))
    op.add_column(
        "users",
        sa.Column("login_otp_expires_at", sa.DateTime(timezone=True), nullable=True),
    )
