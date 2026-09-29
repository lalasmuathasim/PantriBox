from __future__ import annotations

from typing import Protocol

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.domains.households.contracts import HouseholdMemberInput, HouseholdMemberRecord
from app.domains.households.models import HouseholdMember


class HouseholdMemberRepository(Protocol):
    def list_members(
        self, household_id: str, *, include_inactive: bool
    ) -> list[HouseholdMemberRecord]: ...

    def find_member(self, household_id: str, member_id: str) -> HouseholdMemberRecord | None: ...

    def create_member(
        self, household_id: str, member: HouseholdMemberInput
    ) -> HouseholdMemberRecord: ...

    def update_member(
        self, household_id: str, member_id: str, member: HouseholdMemberInput
    ) -> HouseholdMemberRecord | None: ...


class SqlAlchemyHouseholdMemberRepository:
    def __init__(self, session: Session) -> None:
        self._session = session

    def list_members(
        self, household_id: str, *, include_inactive: bool
    ) -> list[HouseholdMemberRecord]:
        statement = select(HouseholdMember).where(HouseholdMember.household_id == household_id)
        if not include_inactive:
            statement = statement.where(HouseholdMember.is_active.is_(True))
        statement = statement.order_by(HouseholdMember.display_name)
        return [_to_record(member) for member in self._session.scalars(statement)]

    def find_member(self, household_id: str, member_id: str) -> HouseholdMemberRecord | None:
        member = self._session.scalar(
            select(HouseholdMember).where(
                HouseholdMember.household_id == household_id,
                HouseholdMember.id == member_id,
            )
        )
        return _to_record(member) if member is not None else None

    def create_member(
        self, household_id: str, member: HouseholdMemberInput
    ) -> HouseholdMemberRecord:
        model = HouseholdMember(
            household_id=household_id,
            display_name=member.display_name,
            date_of_birth=member.date_of_birth,
            sex=member.sex,
            is_active=member.is_active,
        )
        self._session.add(model)
        self._session.commit()
        self._session.refresh(model)
        return _to_record(model)

    def update_member(
        self, household_id: str, member_id: str, member: HouseholdMemberInput
    ) -> HouseholdMemberRecord | None:
        model = self._session.scalar(
            select(HouseholdMember).where(
                HouseholdMember.household_id == household_id,
                HouseholdMember.id == member_id,
            )
        )
        if model is None:
            return None
        model.display_name = member.display_name
        model.date_of_birth = member.date_of_birth
        model.sex = member.sex
        model.is_active = member.is_active
        self._session.commit()
        self._session.refresh(model)
        return _to_record(model)


def _to_record(member: HouseholdMember) -> HouseholdMemberRecord:
    return HouseholdMemberRecord(
        id=member.id,
        household_id=member.household_id,
        display_name=member.display_name,
        date_of_birth=member.date_of_birth,
        sex=member.sex,
        is_active=member.is_active,
    )
