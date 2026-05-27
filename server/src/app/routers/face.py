"""
Face registration & verification router.

Endpoints (all require JWT — get_current_user):
- POST /auth/face/register  → Register face embedding
- POST /auth/face/verify    → Verify face against registered embedding
- GET  /auth/face/status    → Check if face is registered

PRD REQ-001: Face-based caregiver authentication.
"""
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from src.app.core.auth import get_current_user
from src.app.schemas.face import (
    FaceRegisterRequest,
    FaceRegisterResponse,
    FaceStatusResponse,
    FaceVerifyRequest,
    FaceVerifyResponse,
)
from src.app.services import face_service
from src.database.models.user import User
from src.database.session import get_db

router = APIRouter(prefix="/auth/face", tags=["auth/face"])


@router.post(
    "/register",
    response_model=FaceRegisterResponse,
    status_code=status.HTTP_200_OK,
    summary="Register the current caregiver's face embedding",
)
async def register_face(
    payload: FaceRegisterRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> FaceRegisterResponse:
    """Extract a face embedding from the uploaded image and store it on the user record."""
    if not face_service.is_available():
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Face recognition service is not available on the server",
        )

    embedding = face_service.extract_face_embedding(payload.base64_image)
    if embedding is None:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No face detected in the image. Please provide a clear frontal face photo.",
        )

    current_user.face_embedding = face_service.serialize_embedding(embedding)
    await db.commit()

    return FaceRegisterResponse(
        message="Face registered successfully",
        face_registered=True,
    )


@router.post(
    "/verify",
    response_model=FaceVerifyResponse,
    status_code=status.HTTP_200_OK,
    summary="Verify the caregiver's face against registered embedding",
)
async def verify_face(
    payload: FaceVerifyRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> FaceVerifyResponse:
    """Compare the uploaded face image against the caregiver's stored embedding."""
    if not current_user.face_embedding:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No face registered. Please register your face first.",
        )

    if not face_service.is_available():
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Face recognition service is not available on the server",
        )

    login_embedding = face_service.extract_face_embedding(payload.base64_image)
    if login_embedding is None:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No face detected in the image. Please provide a clear frontal face photo.",
        )

    stored_embedding = face_service.deserialize_embedding(current_user.face_embedding)
    is_match, score = face_service.verify_face(stored_embedding, login_embedding)

    if is_match:
        return FaceVerifyResponse(
            success=True,
            similarity=score,
            message=f"Face verified (similarity: {score:.2f})",
        )
    else:
        return FaceVerifyResponse(
            success=False,
            similarity=score,
            message=f"Face does not match (similarity: {score:.2f}, threshold: 0.65)",
        )


@router.get(
    "/status",
    response_model=FaceStatusResponse,
    summary="Check if the current caregiver has a registered face",
)
async def face_status(
    current_user: User = Depends(get_current_user),
) -> FaceStatusResponse:
    """Returns whether the caregiver has registered their face embedding."""
    return FaceStatusResponse(face_registered=current_user.face_embedding is not None)
