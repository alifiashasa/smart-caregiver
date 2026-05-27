"""
Face recognition service using InsightFace buffalo_l model.

Extracts 512-dim face embeddings and compares via cosine similarity.
Threshold: 0.65 (cosine similarity, higher = more similar).

PRD REQ-001: Face registration at caregiver signup + face verification at login.
"""
import base64
import pickle
from typing import Optional

import structlog

logger = structlog.get_logger()

# ── Lazy model loader ────────────────────────────────────────────────────────
_face_model = None


def _get_model():
    """Lazy-load InsightFace buffalo_l model (downloads ~200MB on first call)."""
    global _face_model
    if _face_model is not None:
        return _face_model
    try:
        import insightface
        from insightface.app import FaceAnalysis

        app = FaceAnalysis(name="buffalo_l", root="~/.insightface", providers=["CPUExecutionProvider"])
        app.prepare(ctx_id=0, det_size=(640, 640))
        _face_model = app
        logger.info("face_service", msg="InsightFace buffalo_l model loaded")
    except ImportError:
        logger.warning("face_service", msg="insightface not installed, face features disabled")
        _face_model = False
    except Exception as exc:
        logger.error("face_service", msg="failed to load InsightFace model", error=str(exc))
        _face_model = False
    return _face_model


def is_available() -> bool:
    """Check if the face recognition model is loaded."""
    model = _get_model()
    return model is not False and model is not None


# ── Public API ───────────────────────────────────────────────────────────────

def extract_face_embedding(image_base64: str) -> Optional[list[float]]:
    """
    Extract 512-dim face embedding from a base64-encoded image.

    Returns None if no face is detected or model is unavailable.
    """
    model = _get_model()
    if not model:
        return None

    try:
        image_bytes = base64.b64decode(image_base64)
    except Exception:
        logger.warning("face_service", msg="invalid base64 image")
        return None

    try:
        import cv2
        import numpy as np

        nparr = np.frombuffer(image_bytes, np.uint8)
        img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
        if img is None:
            logger.warning("face_service", msg="failed to decode image")
            return None

        faces = model.get(img)
        if not faces:
            logger.info("face_service", msg="no face detected in image")
            return None

        embedding = faces[0].embedding.tolist()  # type: ignore[union-attr]
        logger.info("face_service", msg="face embedding extracted", dim=len(embedding))
        return embedding
    except Exception as exc:
        logger.error("face_service", msg="face extraction failed", error=str(exc))
        return None


def cosine_similarity(a: list[float], b: list[float]) -> float:
    """
    Compute cosine similarity between two vectors.
    Returns value in [0, 1], higher = more similar.
    """
    import numpy as np

    va = np.array(a, dtype=np.float64)
    vb = np.array(b, dtype=np.float64)
    dot = float(np.dot(va, vb))
    norm_a = float(np.linalg.norm(va))
    norm_b = float(np.linalg.norm(vb))
    if norm_a == 0.0 or norm_b == 0.0:
        return 0.0
    return round(dot / (norm_a * norm_b), 4)


def verify_face(
    stored_embedding: list[float],
    login_embedding: list[float],
    threshold: float = 0.65,
) -> tuple[bool, float]:
    """
    Compare two embeddings.

    Returns (is_match, similarity_score).
    """
    score = cosine_similarity(stored_embedding, login_embedding)
    is_match = score >= threshold
    logger.info(
        "face_service",
        msg="face verification",
        similarity=score,
        threshold=threshold,
        match=is_match,
    )
    return is_match, score


# ── Serialization helpers ────────────────────────────────────────────────────

def serialize_embedding(embedding: list[float]) -> bytes:
    """Pickle embedding list to bytes for DB storage."""
    return pickle.dumps(embedding)


def deserialize_embedding(data: bytes) -> list[float]:
    """Unpickle bytes back to embedding list."""
    return pickle.loads(data)  # nosec — trust DB content
