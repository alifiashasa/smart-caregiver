"""
Resend email integration for authentication OTP delivery.
"""

import httpx

from src.app.core.config import settings

RESEND_EMAILS_URL = "https://api.resend.com/emails"


async def send_email(
    *, to_email: str, subject: str, text: str, html: str
) -> None:
    """Send a generic email through Resend."""
    if not settings.RESEND_API_KEY:
        raise RuntimeError("Resend API key is not configured")

    payload = {
        "from": settings.RESEND_FROM_EMAIL,
        "to": [to_email],
        "subject": subject,
        "text": text,
        "html": html,
    }

    async with httpx.AsyncClient(timeout=10.0) as client:
        response = await client.post(
            RESEND_EMAILS_URL,
            headers={"Authorization": f"Bearer {settings.RESEND_API_KEY}"},
            json=payload,
        )

    if response.status_code >= 400:
        raise RuntimeError("Failed to send email")


async def send_email_verification_otp(
    *, to_email: str, otp_code: str, expires_in_minutes: int
) -> None:
    """Send caregiver email verification OTP through Resend."""
    subject = "Smart Caregiver email verification OTP"
    text = (
        f"Your Smart Caregiver email verification OTP is {otp_code}. "
        f"It expires in {expires_in_minutes} minutes."
    )
    html = f"""
    <div style="font-family: Arial, sans-serif; line-height: 1.5; color: #111827;">
      <h2>Smart Caregiver Email Verification</h2>
      <p>Use this 6-digit OTP to verify caregiver email ownership and activate your account.</p>
      <p style="font-size: 28px; font-weight: 700; letter-spacing: 6px;">{otp_code}</p>
      <p>This code expires in {expires_in_minutes} minutes.</p>
      <p>If you did not request this verification, ignore this email.</p>
    </div>
    """

    try:
        await send_email(to_email=to_email, subject=subject, text=text, html=html)
    except RuntimeError as e:
        raise RuntimeError("Failed to send email verification OTP") from e
