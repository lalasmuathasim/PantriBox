from sqlalchemy import ForeignKey, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.domains.common import TimestampedModel


class Household(TimestampedModel):
    __tablename__ = "households"

    name: Mapped[str] = mapped_column(String(120))
    owner_user_id: Mapped[str] = mapped_column(ForeignKey("users.id"))


class HouseholdMember(TimestampedModel):
    __tablename__ = "household_members"

    household_id: Mapped[str] = mapped_column(ForeignKey("households.id"))
    user_id: Mapped[str | None] = mapped_column(ForeignKey("users.id"), nullable=True)
    display_name: Mapped[str] = mapped_column(String(120))

    household = relationship("Household")
