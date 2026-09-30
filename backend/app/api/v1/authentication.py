from datetime import timedelta
from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel, Field
from sqlalchemy.orm import Session

from app.core.config.settings import Settings, get_settings
from app.db.session import get_db_session
from app.domains.users.repository import SqlAlchemyDevelopmentAuthenticationRepository
from app.services.development_authentication_service import (
    DevelopmentAuthenticationService,
    PasswordHasher,
)

router = APIRouter()


class LoginRequest(BaseModel):
    email: str = Field(min_length=3, max_length=320)
    password: str = Field(min_length=1, max_length=512)


class LoginUserResponse(BaseModel):
    id: str
    full_name: str | None
    platform_role: str


class LoginResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    expires_at: str
    user: LoginUserResponse


def get_development_authentication_service(
    db: Annotated[Session, Depends(get_db_session)],
    settings: Annotated[Settings, Depends(get_settings)],
) -> DevelopmentAuthenticationService:
    if not settings.is_development_auth_enabled:
        raise HTTPException(status_code=404, detail="Development authentication is unavailable.")
    return DevelopmentAuthenticationService(
        SqlAlchemyDevelopmentAuthenticationRepository(db),
        PasswordHasher(),
        session_duration=timedelta(hours=settings.development_auth_session_hours),
    )


@router.post("/login", response_model=LoginResponse)
def login(
    request: LoginRequest,
    service: Annotated[
        DevelopmentAuthenticationService, Depends(get_development_authentication_service)
    ],
) -> LoginResponse:
    result = service.login(request.email, request.password)
    return LoginResponse(
        access_token=result.access_token,
        expires_at=result.expires_at.isoformat(),
        user=LoginUserResponse(
            id=result.user.id,
            full_name=result.user.full_name,
            platform_role=result.user.platform_role,
        ),
    )
