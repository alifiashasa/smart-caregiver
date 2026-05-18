from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException
from fastapi.exceptions import RequestValidationError
from dotenv import load_dotenv
from slowapi import _rate_limit_exceeded_handler
from slowapi.errors import RateLimitExceeded

from src.app.core.config import settings
from src.app.core.logging import RequestLoggingMiddleware, get_logger, setup_logging
from src.app.core.error_handlers import (
    http_exception_handler,
    unhandled_exception_handler,
    validation_exception_handler,
)
from src.app.core.rate_limiter import limiter
from src.app.core.scheduler import start_scheduler, stop_scheduler
from src.app.routers import health, elderly
from src.app.routers import auth as auth_router
from src.app.routers import dashboard
from src.app.routers import notification
from src.app.routers import schedule
from src.app.routers import recommendation
from src.app.routers import internal_jobs

# Load .env file
load_dotenv()

logger = get_logger()


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    start_scheduler()
    yield
    # Shutdown
    stop_scheduler()


app = FastAPI(
    title="Smart Caregiver API",
    description="Backend API for Smart Caregiver Application",
    version="1.0.0",
    lifespan=lifespan,
)

# ── Logging 
setup_logging(debug=settings.DEBUG)
app.add_middleware(RequestLoggingMiddleware)

# ── Exception handlers 
app.add_exception_handler(HTTPException, http_exception_handler)
app.add_exception_handler(RequestValidationError, validation_exception_handler)
app.add_exception_handler(Exception, unhandled_exception_handler)

# ── Rate limiter 
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

# ── Routers 
app.include_router(auth_router.router)
app.include_router(elderly.router)
app.include_router(health.router)
app.include_router(dashboard.router)
app.include_router(notification.router, prefix="/notifications")
app.include_router(schedule.router)
app.include_router(recommendation.router)
app.include_router(internal_jobs.router)


@app.get("/")
async def root():
    return {
        "message": "Welcome to Smart Caregiver API",
        "docs": "/docs"
    }


@app.get("/health-check")
async def health_check():
    return {"status": "healthy"}
