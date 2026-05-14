"""
Resend email integration for authentication OTP delivery.
"""

import httpx

from src.app.core.config import settings

RESEND_EMAILS_URL = "https://api.resend.com/emails"


async def send_login_otp_email(*, to_email: str, otp_code: str, expires_in_minutes: int) -> None:
    """Send caregiver login OTP through Resend."""
    if not settings.RESEND_API_KEY:
        raise RuntimeError("Resend API key is not configured")

    subject = "Smart Caregiver login OTP"
    text = (
        f"Your Smart Caregiver login OTP is {otp_code}. "
        f"It expires in {expires_in_minutes} minutes."
    )
    html = f"""
    <div style="font-family: Arial, sans-serif; line-height: 1.5; color: #111827;">
      <h2>Smart Caregiver Login Verification</h2>
      <p>Use this 6-digit OTP to verify caregiver email ownership and complete login.</p>
      <p style="font-size: 28px; font-weight: 700; letter-spacing: 6px;">{otp_code}</p>
      <p>This code expires in {expires_in_minutes} minutes.</p>
      <p>If you did not request this login, ignore this email.</p>
    </div>
    """

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
        raise RuntimeError("Failed to send login OTP email")
