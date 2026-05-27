"""
Google OAuth Authentication Router.

Endpoints:
- POST /auth/google/login  → Authenticate or register with Google ID token

Flow:
  Mobile app gets id_token from Google Sign-In SDK
  → sends {id_token} to this endpoint
  → backend verifies with google-auth library
  → creates/links user and returns JWT tokens
"""

from fastapi import APIRouter, Depends, HTTPException, Request, status
from sqlalchemy.ext.asyncio import AsyncSession

from src.app.schemas.auth import GoogleLoginRequest, TokenResponse
from src.app.services import oauth_google
from src.app.core.rate_limiter import limiter
from src.database.session import get_db

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post(
    "/google/login",
    response_model=TokenResponse,
    summary="Login or register with Google OAuth",
    description=(
        "Accepts a Google ID token obtained from the Google Sign-In SDK "
        "(mobile or web). Verifies the token, finds or creates a user, "
        "and returns JWT access + refresh tokens."
    ),
)
@limiter.limit("10/minute")
async def google_login(
    request: Request,
    payload: GoogleLoginRequest,
    db: AsyncSession = Depends(get_db),
) -> TokenResponse:
    """Authenticate or register using a Google ID token."""
    try:
        tokens = await oauth_google.google_login(db=db, id_token=payload.id_token)
        await db.commit()
        return tokens
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=str(e),
            headers={"WWW-Authenticate": "Bearer"},
        )
