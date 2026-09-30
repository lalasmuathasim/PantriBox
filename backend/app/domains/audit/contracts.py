from dataclasses import dataclass


@dataclass(frozen=True, slots=True)
class AuditEventInput:
    actor_user_id: str | None
    event_type: str
    resource_type: str
    resource_id: str | None = None
    household_id: str | None = None
    details: dict[str, object] | None = None
