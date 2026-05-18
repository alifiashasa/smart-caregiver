"""
Application configuration using pydantic-settings.
All sensitive values come from environment variables / .env file.

pip install pydantic-settings
"""

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore",
    )

    # ── App ───────────────────────────────────────────────────────────────────
    APP_NAME: str = "CaregiverApp"
    DEBUG: bool = False

    # ── Database (Neon PostgreSQL) ────────────────────────────────────────────
    # Format: postgresql+asyncpg://user:password@host/dbname
    DATABASE_URL: str
    DB_ECHO: bool = False

    # ── JWT ───────────────────────────────────────────────────────────────────
    SECRET_KEY: str                        # openssl rand -hex 32
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    REFRESH_TOKEN_EXPIRE_DAYS: int = 7

    # ── GROQ (AI Recommendations) ────────────────────────────────────────────────
    GROQ_API_KEY: str = ""

    # ── Resend (Email OTP) ────────────────────────────────────────────────────
    RESEND_API_KEY: str = ""
    RESEND_FROM_EMAIL: str = "Smart Caregiver <onboarding@resend.dev>"
    EMAIL_OTP_EXPIRE_MINUTES: int = 5

    # ── Internal API ──────────────────────────────────────────────────────────
    INTERNAL_API_KEY: str = ""

    # ── CORS ──────────────────────────────────────────────────────────────────
    ALLOWED_ORIGINS: list[str] = ["http://localhost:3000"]


settings = Settings()  # type: ignore[call-arg]
