from datetime import date, datetime

from sqlalchemy import Boolean, Date, DateTime, ForeignKey, String, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.domains.common import HouseholdInvitationStatus, HouseholdRole, TimestampedModel


class Household(TimestampedModel):
    __tablename__ = "households"

    name: Mapped[str] = mapped_column(String(120))
    owner_user_id: Mapped[str] = mapped_column(ForeignKey("users.id"))


class HouseholdMember(TimestampedModel):
    __tablename__ = "household_members"
    __table_args__ = (UniqueConstraint("household_id", "user_id"),)

    household_id: Mapped[str] = mapped_column(ForeignKey("households.id"))
    user_id: Mapped[str | None] = mapped_column(ForeignKey("users.id"), nullable=True)
    display_name: Mapped[str] = mapped_column(String(120))
    date_of_birth: Mapped[date | None] = mapped_column(Date, nullable=True)
    sex: Mapped[str | None] = mapped_column(String(16), nullable=True)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)

    household = relationship("Household")


class HouseholdMembership(TimestampedModel):
    __tablename__ = "household_memberships"
    __table_args__ = (UniqueConstraint("household_id", "user_id"),)

    household_id: Mapped[str] = mapped_column(ForeignKey("households.id"), index=True)
    user_id: Mapped[str] = mapped_column(ForeignKey("users.id"), index=True)
    role: Mapped[str] = mapped_column(String(32), default=HouseholdRole.MEMBER.value)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)

    household = relationship("Household")


class HouseholdInvitation(TimestampedModel):
    __tablename__ = "household_invitations"

    household_id: Mapped[str] = mapped_column(ForeignKey("households.id"), index=True)
    invitee_email: Mapped[str] = mapped_column(String(320), index=True)
    role: Mapped[str] = mapped_column(String(32), default=HouseholdRole.MEMBER.value)
    status: Mapped[str] = mapped_column(
        String(32), default=HouseholdInvitationStatus.PENDING.value, index=True
    )
    # Only a cryptographic hash is persisted; delivery is a future integration.
    token_hash: Mapped[str] = mapped_column(String(255), unique=True)
    expires_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    invited_by_user_id: Mapped[str] = mapped_column(ForeignKey("users.id"))
    accepted_by_user_id: Mapped[str | None] = mapped_column(ForeignKey("users.id"), nullable=True)

    household = relationship("Household")
