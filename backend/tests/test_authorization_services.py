import pytest

from app.core.errors.exceptions import PantriBoxError
from app.domains.audit.contracts import AuditEventInput
from app.domains.households.contracts import HouseholdMembershipRecord
from app.domains.users.contracts import UserRoleRecord
from app.services.admin_service import PlatformAdministrationService
from app.services.authorization_service import (
    AuthenticatedPrincipal,
    HouseholdAuthorizationService,
    HouseholdPermission,
    PlatformAuthorizationService,
)


class InMemoryMembershipRepository:
    def __init__(self, memberships: list[HouseholdMembershipRecord]) -> None:
        self._memberships = {(item.household_id, item.user_id): item for item in memberships}

    def find_active_membership(self, household_id: str, user_id: str):
        membership = self._memberships.get((household_id, user_id))
        return membership if membership is not None and membership.is_active else None


class InMemoryUserRoleRepository:
    def __init__(self) -> None:
        self.records = {
            "target-user": UserRoleRecord(
                id="target-user",
                platform_role="user",
                account_status="active",
                is_active=True,
            )
        }

    def assign_platform_role(self, user_id: str, platform_role: str):
        record = self.records.get(user_id)
        if record is None:
            return None
        updated = UserRoleRecord(
            id=record.id,
            platform_role=platform_role,
            account_status=record.account_status,
            is_active=record.is_active,
        )
        self.records[user_id] = updated
        return updated


class InMemoryAuditEventRepository:
    def __init__(self) -> None:
        self.events: list[AuditEventInput] = []

    def record(self, event: AuditEventInput) -> None:
        self.events.append(event)


def _principal(
    user_id: str, *, role: str = "user", account_status: str = "active"
) -> AuthenticatedPrincipal:
    return AuthenticatedPrincipal(
        user_id=user_id,
        platform_role=role,
        account_status=account_status,
        is_active=True,
    )


def test_platform_role_assignment_requires_super_admin_and_records_an_audit_event() -> None:
    users = InMemoryUserRoleRepository()
    audit_events = InMemoryAuditEventRepository()
    service = PlatformAdministrationService(
        users=users,
        audit_events=audit_events,
        authorization=PlatformAuthorizationService(),
    )

    with pytest.raises(PantriBoxError, match="Platform permission"):
        service.assign_platform_role(
            actor=_principal("ordinary-user"),
            target_user_id="target-user",
            platform_role="admin",
        )

    updated = service.assign_platform_role(
        actor=_principal("super-admin", role="super_admin"),
        target_user_id="target-user",
        platform_role="admin",
    )

    assert updated.platform_role == "admin"
    assert audit_events.events == [
        AuditEventInput(
            actor_user_id="super-admin",
            event_type="platform_role_assigned",
            resource_type="user",
            resource_id="target-user",
            details={"platform_role": "admin"},
        )
    ]


def test_users_cannot_elevate_their_own_platform_role() -> None:
    service = PlatformAdministrationService(
        users=InMemoryUserRoleRepository(),
        audit_events=InMemoryAuditEventRepository(),
        authorization=PlatformAuthorizationService(),
    )

    with pytest.raises(PantriBoxError, match="own platform role"):
        service.assign_platform_role(
            actor=_principal("target-user", role="super_admin"),
            target_user_id="target-user",
            platform_role="super_admin",
        )


def test_platform_administration_does_not_grant_household_access() -> None:
    authorization = HouseholdAuthorizationService(
        InMemoryMembershipRepository(
            [
                HouseholdMembershipRecord(
                    household_id="household-1",
                    user_id="viewer-user",
                    role="viewer",
                    is_active=True,
                )
            ]
        )
    )

    with pytest.raises(PantriBoxError, match="Household permission"):
        authorization.require_permission(
            _principal("platform-admin", role="super_admin"),
            "household-1",
            HouseholdPermission.READ,
        )

    authorization.require_permission(
        _principal("viewer-user"), "household-1", HouseholdPermission.READ
    )
    with pytest.raises(PantriBoxError, match="Household permission"):
        authorization.require_permission(
            _principal("viewer-user"),
            "household-1",
            HouseholdPermission.MANAGE_PURCHASES,
        )


def test_inactive_accounts_cannot_use_household_permissions() -> None:
    authorization = HouseholdAuthorizationService(
        InMemoryMembershipRepository(
            [
                HouseholdMembershipRecord(
                    household_id="household-1",
                    user_id="member-user",
                    role="member",
                    is_active=True,
                )
            ]
        )
    )

    with pytest.raises(PantriBoxError, match="active account"):
        authorization.require_permission(
            _principal("member-user", account_status="suspended"),
            "household-1",
            HouseholdPermission.READ,
        )
