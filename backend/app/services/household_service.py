from __future__ import annotations

from datetime import date

from app.core.errors.exceptions import PantriBoxError
from app.domains.common import HouseholdMemberSex
from app.domains.households.contracts import HouseholdMemberInput, HouseholdMemberRecord
from app.domains.households.repository import HouseholdMemberRepository


class HouseholdService:
    def __init__(self, repository: HouseholdMemberRepository) -> None:
        self._repository = repository

    def list_members(
        self, household_id: str, *, include_inactive: bool = False
    ) -> list[HouseholdMemberRecord]:
        return self._repository.list_members(household_id, include_inactive=include_inactive)

    def create_member(
        self, household_id: str, member: HouseholdMemberInput
    ) -> HouseholdMemberRecord:
        return self._repository.create_member(household_id, self._validate(member))

    def update_member(
        self, household_id: str, member_id: str, member: HouseholdMemberInput
    ) -> HouseholdMemberRecord:
        updated = self._repository.update_member(household_id, member_id, self._validate(member))
        if updated is None:
            raise PantriBoxError("Household member was not found.", status_code=404)
        return updated

    def deactivate_member(self, household_id: str, member_id: str) -> HouseholdMemberRecord:
        existing = self._repository.find_member(household_id, member_id)
        if existing is None:
            raise PantriBoxError("Household member was not found.", status_code=404)
        return self.update_member(
            household_id,
            member_id,
            HouseholdMemberInput(
                display_name=existing.display_name,
                date_of_birth=existing.date_of_birth,
                sex=existing.sex,
                is_active=False,
            ),
        )

    @staticmethod
    def _validate(member: HouseholdMemberInput) -> HouseholdMemberInput:
        name = member.display_name.strip()
        if not name:
            raise PantriBoxError("A household member name is required.", status_code=422)
        if member.date_of_birth is not None and member.date_of_birth > date.today():
            raise PantriBoxError("Date of birth cannot be in the future.", status_code=422)
        if member.sex is not None and member.sex not in {item.value for item in HouseholdMemberSex}:
            raise PantriBoxError("Sex must use a supported value.", status_code=422)
        return HouseholdMemberInput(
            display_name=name,
            date_of_birth=member.date_of_birth,
            sex=member.sex,
            is_active=member.is_active,
        )
