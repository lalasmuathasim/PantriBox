from __future__ import annotations

from datetime import date
from typing import Annotated

from fastapi import APIRouter, Depends, Query, Response
from pydantic import BaseModel, Field
from sqlalchemy.orm import Session

from app.db.session import get_db_session
from app.domains.households.contracts import HouseholdMemberInput, HouseholdMemberRecord
from app.domains.households.repository import SqlAlchemyHouseholdMemberRepository
from app.services.household_service import HouseholdService

router = APIRouter()


class HouseholdMemberRequest(BaseModel):
    display_name: str = Field(min_length=1, max_length=120)
    date_of_birth: date | None = None
    sex: str | None = Field(default=None, max_length=16)
    is_active: bool = True


class HouseholdMemberResponse(BaseModel):
    id: str
    household_id: str
    display_name: str
    date_of_birth: date | None
    sex: str | None
    is_active: bool


def get_household_service(
    db: Annotated[Session, Depends(get_db_session)],
) -> HouseholdService:
    return HouseholdService(SqlAlchemyHouseholdMemberRepository(db))


@router.get("/{household_id}/members", response_model=list[HouseholdMemberResponse])
def list_members(
    household_id: str,
    service: Annotated[HouseholdService, Depends(get_household_service)],
    include_inactive: bool = Query(default=False),
) -> list[HouseholdMemberResponse]:
    return [
        _member_response(member)
        for member in service.list_members(household_id, include_inactive=include_inactive)
    ]


@router.post("/{household_id}/members", response_model=HouseholdMemberResponse, status_code=201)
def create_member(
    household_id: str,
    request: HouseholdMemberRequest,
    service: Annotated[HouseholdService, Depends(get_household_service)],
) -> HouseholdMemberResponse:
    return _member_response(service.create_member(household_id, _member_input(request)))


@router.put("/{household_id}/members/{member_id}", response_model=HouseholdMemberResponse)
def update_member(
    household_id: str,
    member_id: str,
    request: HouseholdMemberRequest,
    service: Annotated[HouseholdService, Depends(get_household_service)],
) -> HouseholdMemberResponse:
    return _member_response(service.update_member(household_id, member_id, _member_input(request)))


@router.delete("/{household_id}/members/{member_id}", status_code=204)
def deactivate_member(
    household_id: str,
    member_id: str,
    service: Annotated[HouseholdService, Depends(get_household_service)],
) -> Response:
    service.deactivate_member(household_id, member_id)
    return Response(status_code=204)


def _member_input(request: HouseholdMemberRequest) -> HouseholdMemberInput:
    return HouseholdMemberInput(
        display_name=request.display_name,
        date_of_birth=request.date_of_birth,
        sex=request.sex,
        is_active=request.is_active,
    )


def _member_response(member: HouseholdMemberRecord) -> HouseholdMemberResponse:
    return HouseholdMemberResponse(
        id=member.id,
        household_id=member.household_id,
        display_name=member.display_name,
        date_of_birth=member.date_of_birth,
        sex=member.sex,
        is_active=member.is_active,
    )
