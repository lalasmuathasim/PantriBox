from typing import Annotated

from fastapi import APIRouter, Depends

from app.services.system_service import SystemService

router = APIRouter()


def get_system_service() -> SystemService:
    return SystemService()


@router.get("/health")
def health(
    service: Annotated[SystemService, Depends(get_system_service)],
) -> dict[str, object]:
    return service.get_health()


@router.get("/version")
def version(
    service: Annotated[SystemService, Depends(get_system_service)],
) -> dict[str, object]:
    return service.get_version()
