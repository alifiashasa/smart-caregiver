"""
Authentication Router.

Endpoints:
- POST /auth/register     → Register with email + password and send OTP
- POST /auth/login        → Login with email + password
- POST /auth/verify-otp   → Verify registration OTP and activate account
- POST /auth/refresh      → Refresh access token
- GET  /auth/me           → Get current user profile

"""

from fastapi import APIRouter, Depends, HTTPException, Request, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.ext.asyncio import AsyncSession

from src.app.core.auth import get_current_user
from src.app.core.rate_limiter import limiter
from src.app.schemas.auth import (
    LoginOtpResponse,
    MessageResponse,
    TokenResponse,
    TokenRefreshRequest,
    UserLoginRequest,
    UserMeResponse,
    UserRegisterRequest,
    UserUpdateRequest,
    VerifyOtpRequest,
)
from src.app.services import auth_service
from src.database.models.user import User
from src.database.session import get_db

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post(
    "/register",
    response_model=LoginOtpResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Register new account with email + password and send OTP",
    description=(
        "Creates a new caregiver account with email and password authentication, "
        "then sends a 6-digit OTP to verify caregiver email ownership. "
        "Verify OTP once to activate the account."
    ),
)
@limiter.limit("5/minute")
async def register(
    request: Request,
    payload: UserRegisterRequest,
    db: AsyncSession = Depends(get_db),
) -> LoginOtpResponse:
    """Register a new caregiver, then send OTP."""
    try:
        _user, otp_response = await auth_service.register_user_with_otp(db=db, payload=payload)
        await db.commit()
        return otp_response
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e),
        )
    except RuntimeError as e:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail=str(e),
        )


@router.post(
    "/login",
    response_model=TokenResponse,
    summary="Login with email + password (form-data)",
    description=(
        "Authenticates verified caregiver with email and password. "
        "Returns JWT access and refresh tokens. Use form-data content type."
    ),
)
@limiter.limit("10/minute")
async def login_form(
    request: Request,
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: AsyncSession = Depends(get_db),
) -> TokenResponse:
    """Login verified caregiver with email + password (form-data format)."""
    try:
        payload = UserLoginRequest(email=form_data.username, password=form_data.password)
        _user, tokens = await auth_service.authenticate_user(db=db, payload=payload)
        await db.commit()
        return tokens
    except PermissionError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=str(e),
        )
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=str(e),
            headers={"WWW-Authenticate": "Bearer"},
        )


@router.post(
    "/login/json",
    response_model=TokenResponse,
    summary="Login with email + password (JSON)",
    description=(
        "Authenticates verified caregiver with email and password. "
        "Returns JWT access and refresh tokens. "
        "Use JSON content type with 'email' and 'password' fields."
    ),
)
@limiter.limit("10/minute")
async def login_json(
    request: Request,
    payload: UserLoginRequest,
    db: AsyncSession = Depends(get_db),
) -> TokenResponse:
    """Login verified caregiver with email + password (JSON format)."""
    try:
        _user, tokens = await auth_service.authenticate_user(db=db, payload=payload)
        await db.commit()
        return tokens
    except PermissionError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=str(e),
        )
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=str(e),
            headers={"WWW-Authenticate": "Bearer"},
        )


@router.post(
    "/verify-otp",
    response_model=MessageResponse,
    summary="Verify caregiver registration OTP",
    description=(
        "Verifies the 6-digit OTP sent to caregiver email after registration. "
        "Activates the account when OTP is valid."
    ),
)
@limiter.limit("10/minute")
async def verify_otp(
    request: Request,
    payload: VerifyOtpRequest,
    db: AsyncSession = Depends(get_db),
) -> MessageResponse:
    """Verify registration OTP and activate caregiver account."""
    try:
        await auth_service.verify_registration_otp(db=db, payload=payload)
        await db.commit()
        return MessageResponse(message="Email verified. Account is active.")
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e),
        )


@router.post(
    "/refresh",
    response_model=TokenResponse,
    summary="Refresh access token",
    description=(
        "Use refresh token to obtain new access token. "
        "Both access and refresh tokens are returned."
    ),
)
@limiter.limit("10/minute")
async def refresh(
    request: Request,
    payload: TokenRefreshRequest,
    db: AsyncSession = Depends(get_db),
) -> TokenResponse:
    """Refresh access token using refresh token."""
    try:
        tokens = await auth_service.refresh_access_token(db=db, refresh_token=payload.refresh_token)
        return tokens
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=str(e),
            headers={"WWW-Authenticate": "Bearer"},
        )


@router.get(
    "/me",
    response_model=UserMeResponse,
    summary="Get current user profile",
    description="Returns the profile of the currently authenticated user.",
)
async def get_me(
    current_user: User = Depends(get_current_user),
) -> UserMeResponse:
    """Get current authenticated user profile."""
    return current_user


@router.put(
    "/me",
    response_model=UserMeResponse,
    summary="Update current user profile",
    description="Update caregiver full_name and/or phone.",
)
async def update_me(
    payload: UserUpdateRequest,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> UserMeResponse:
    """Update current authenticated user profile."""
    return await auth_service.update_user_profile(
        db=db, user=current_user, payload=payload
    )