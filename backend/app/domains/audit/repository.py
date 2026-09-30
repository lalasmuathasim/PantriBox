from typing import Protocol

from sqlalchemy.orm import Session

from app.domains.audit.contracts import AuditEventInput
from app.domains.audit.models import AuditEvent


class AuditEventRepository(Protocol):
    def record(self, event: AuditEventInput) -> None: ...


class SqlAlchemyAuditEventRepository:
    def __init__(self, session: Session) -> None:
        self._session = session

    def record(self, event: AuditEventInput) -> None:
        self._session.add(
            AuditEvent(
                actor_user_id=event.actor_user_id,
                household_id=event.household_id,
                event_type=event.event_type,
                resource_type=event.resource_type,
                resource_id=event.resource_id,
                details=event.details,
            )
        )
        self._session.commit()
