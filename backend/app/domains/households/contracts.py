from __future__ import annotations

from dataclasses import dataclass
from datetime import date


@dataclass(frozen=True, slots=True)
class HouseholdMemberRecord:
    id: str
    household_id: str
    display_name: str
    date_of_birth: date | None
    sex: str | None
    is_active: bool


@dataclass(frozen=True, slots=True)
class HouseholdMemberInput:
    display_name: str
    date_of_birth: date | None = None
    sex: str | None = None
    is_active: bool = True


@dataclass(frozen=True, slots=True)
class HouseholdMembershipRecord:
    household_id: str
    user_id: str
    role: str
    is_active: bool
