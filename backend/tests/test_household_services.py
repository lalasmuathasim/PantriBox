from datetime import date, timedelta

import pytest

from app.core.errors.exceptions import PantriBoxError
from app.domains.households.contracts import HouseholdMemberInput, HouseholdMemberRecord
from app.services.household_service import HouseholdService


class InMemoryHouseholdMemberRepository:
    def __init__(self) -> None:
        self.members: dict[str, HouseholdMemberRecord] = {}

    def list_members(self, household_id: str, *, include_inactive: bool):
        return [
            member
            for member in self.members.values()
            if member.household_id == household_id and (include_inactive or member.is_active)
        ]

    def find_member(self, household_id: str, member_id: str):
        member = self.members.get(member_id)
        return member if member is not None and member.household_id == household_id else None

    def create_member(self, household_id: str, member: HouseholdMemberInput):
        record = HouseholdMemberRecord(
            id=f"member-{len(self.members) + 1}",
            household_id=household_id,
            display_name=member.display_name,
            date_of_birth=member.date_of_birth,
            sex=member.sex,
            is_active=member.is_active,
        )
        self.members[record.id] = record
        return record

    def update_member(self, household_id: str, member_id: str, member: HouseholdMemberInput):
        existing = self.find_member(household_id, member_id)
        if existing is None:
            return None
        updated = HouseholdMemberRecord(
            id=existing.id,
            household_id=existing.household_id,
            display_name=member.display_name,
            date_of_birth=member.date_of_birth,
            sex=member.sex,
            is_active=member.is_active,
        )
        self.members[member_id] = updated
        return updated


def test_member_lifecycle_uses_deactivation_not_erasure() -> None:
    service = HouseholdService(InMemoryHouseholdMemberRepository())
    created = service.create_member(
        "household-1",
        HouseholdMemberInput(display_name="  Amina  ", sex="female"),
    )

    deactivated = service.deactivate_member("household-1", created.id)

    assert deactivated.display_name == "Amina"
    assert deactivated.is_active is False
    assert service.list_members("household-1") == []
    assert service.list_members("household-1", include_inactive=True) == [deactivated]


def test_member_service_rejects_unnecessary_or_invalid_profile_data() -> None:
    service = HouseholdService(InMemoryHouseholdMemberRepository())

    with pytest.raises(PantriBoxError, match="name"):
        service.create_member("household-1", HouseholdMemberInput(display_name="  "))
    with pytest.raises(PantriBoxError, match="future"):
        service.create_member(
            "household-1",
            HouseholdMemberInput(
                display_name="Amina",
                date_of_birth=date.today() + timedelta(days=1),
            ),
        )
