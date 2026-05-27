"""
Face registration & verification schemas.

PRD REQ-001: face-based caregiver authentication.
"""
from pydantic import BaseModel, Field


class FaceRegisterRequest(BaseModel):
    """Upload a face image (base64) to register the caregiver's face."""

    base64_image: str = Field(..., description="Base64-encoded JPEG/PNG image of the caregiver's face")


class FaceRegisterResponse(BaseModel):
    """Result of face registration."""

    message: str
    face_registered: bool


class FaceVerifyRequest(BaseModel):
    """Upload a face image (base64) to verify against registered embedding."""

    base64_image: str = Field(..., description="Base64-encoded JPEG/PNG image of the caregiver's face")


class FaceStatusResponse(BaseModel):
    """Whether the current user has a registered face embedding."""

    face_registered: bool


class FaceVerifyResponse(BaseModel):
    """Result of face verification during login."""

    success: bool
    similarity: float
    message: str
