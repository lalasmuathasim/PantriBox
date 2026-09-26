from sqlalchemy import Boolean, String
from sqlalchemy.orm import Mapped, mapped_column

from app.domains.common import TimestampedModel


class User(TimestampedModel):
    __tablename__ = "users"

    email: Mapped[str] = mapped_column(String(320), unique=True, index=True)
    full_name: Mapped[str | None] = mapped_column(String(120), nullable=True)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
