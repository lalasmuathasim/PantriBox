from __future__ import annotations

from dataclasses import dataclass
from enum import StrEnum

from app.core.errors.exceptions import PantriBoxError
from app.domains.common import AccountStatus, HouseholdRole, PlatformRole
from app.domains.households.repository import HouseholdMembershipRepository


class PlatformPermission(StrEnum):
    MANAGE_PLATFORM_ROLES = "manage_platform_roles"
    VIEW_AUDIT_EVENTS = "view_audit_events"


class HouseholdPermission(StrEnum):
    READ = "read"
    MANAGE_SHOPPING_LISTS = "manage_shopping_lists"
    MANAGE_PURCHASES = "manage_purchases"
    MANAGE_MEMBERS = "manage_members"
    INVITE_MEMBERS = "invite_members"


@dataclass(frozen=True, slots=True)
class AuthenticatedPrincipal:
    user_id: str
    platform_role: str
    account_status: str
    is_active: bool


_PLATFORM_PERMISSIONS: dict[str, frozenset[PlatformPermission]] = {
    PlatformRole.USER.value: frozenset(),
    PlatformRole.ADMIN.value: frozenset({PlatformPermission.VIEW_AUDIT_EVENTS}),
    PlatformRole.SUPER_ADMIN.value: frozenset(PlatformPermission),
}

_HOUSEHOLD_PERMISSIONS: dict[str, frozenset[HouseholdPermission]] = {
    HouseholdRole.OWNER.value: frozenset(HouseholdPermission),
    HouseholdRole.ADMIN.value: frozenset(HouseholdPermission),
    HouseholdRole.MEMBER.value: frozenset(
        {
            HouseholdPermission.READ,
            HouseholdPermission.MANAGE_SHOPPING_LISTS,
            HouseholdPermission.MANAGE_PURCHASES,
        }
    ),
    HouseholdRole.VIEWER.value: frozenset({HouseholdPermission.READ}),
}


class PlatformAuthorizationService:
    def require_permission(
        self, principal: AuthenticatedPrincipal, permission: PlatformPermission
    ) -> None:
        _require_active_account(principal)
        if permission not in _PLATFORM_PERMISSIONS.get(principal.platform_role, frozenset()):
            raise PantriBoxError("Platform permission is required.", status_code=403)


class HouseholdAuthorizationService:
    def __init__(self, memberships: HouseholdMembershipRepository) -> None:
        self._memberships = memberships

    def require_permission(
        self,
        principal: AuthenticatedPrincipal,
        household_id: str,
        permission: HouseholdPermission,
    ) -> None:
        _require_active_account(principal)
        membership = self._memberships.find_active_membership(household_id, principal.user_id)
        if membership is None or permission not in _HOUSEHOLD_PERMISSIONS.get(
            membership.role, frozenset()
        ):
            raise PantriBoxError("Household permission is required.", status_code=403)


def _require_active_account(principal: AuthenticatedPrincipal) -> None:
    if not principal.is_active or principal.account_status != AccountStatus.ACTIVE.value:
        raise PantriBoxError("An active account is required.", status_code=403)
