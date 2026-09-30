from app.core.errors.exceptions import PantriBoxError
from app.domains.audit.contracts import AuditEventInput
from app.domains.audit.repository import AuditEventRepository
from app.domains.common import PlatformRole
from app.domains.users.contracts import UserRoleRecord
from app.domains.users.repository import UserRoleRepository
from app.services.authorization_service import (
    AuthenticatedPrincipal,
    PlatformAuthorizationService,
    PlatformPermission,
)


class PlatformAdministrationService:
    """Applies privileged role changes through one authorized, auditable path."""

    def __init__(
        self,
        *,
        users: UserRoleRepository,
        audit_events: AuditEventRepository,
        authorization: PlatformAuthorizationService,
    ) -> None:
        self._users = users
        self._audit_events = audit_events
        self._authorization = authorization

    def assign_platform_role(
        self,
        *,
        actor: AuthenticatedPrincipal,
        target_user_id: str,
        platform_role: str,
    ) -> UserRoleRecord:
        self._authorization.require_permission(actor, PlatformPermission.MANAGE_PLATFORM_ROLES)
        if actor.user_id == target_user_id:
            raise PantriBoxError("Users cannot change their own platform role.", status_code=403)
        if platform_role not in {role.value for role in PlatformRole}:
            raise PantriBoxError("Platform role is not supported.", status_code=422)
        updated = self._users.assign_platform_role(target_user_id, platform_role)
        if updated is None:
            raise PantriBoxError("User was not found.", status_code=404)
        self._audit_events.record(
            AuditEventInput(
                actor_user_id=actor.user_id,
                event_type="platform_role_assigned",
                resource_type="user",
                resource_id=updated.id,
                details={"platform_role": updated.platform_role},
            )
        )
        return updated
