from sqlalchemy import ForeignKey, String
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.orm import Mapped, mapped_column

from app.domains.common import TimestampedModel


class AuditEvent(TimestampedModel):
    __tablename__ = "audit_events"

    actor_user_id: Mapped[str | None] = mapped_column(
        ForeignKey("users.id"), nullable=True, index=True
    )
    household_id: Mapped[str | None] = mapped_column(
        ForeignKey("households.id"), nullable=True, index=True
    )
    event_type: Mapped[str] = mapped_column(String(120), index=True)
    resource_type: Mapped[str] = mapped_column(String(80))
    resource_id: Mapped[str | None] = mapped_column(String(64), nullable=True)
    details: Mapped[dict[str, object] | None] = mapped_column(JSONB, nullable=True)
