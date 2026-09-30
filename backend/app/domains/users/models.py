from datetime import datetime

from sqlalchemy import Boolean, DateTime, ForeignKey, String, Text, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.domains.common import AccountStatus, PlatformRole, TimestampedModel


class User(TimestampedModel):
    __tablename__ = "users"

    # Legacy primary email remains available while provider identities evolve.
    email: Mapped[str | None] = mapped_column(String(320), unique=True, index=True, nullable=True)
    email_verified_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True
    )
    mobile_e164: Mapped[str | None] = mapped_column(
        String(32), unique=True, index=True, nullable=True
    )
    mobile_verified_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True
    )
    full_name: Mapped[str | None] = mapped_column(String(120), nullable=True)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    account_status: Mapped[str] = mapped_column(String(32), default=AccountStatus.ACTIVE.value)
    platform_role: Mapped[str] = mapped_column(String(32), default=PlatformRole.USER.value)

    identities: Mapped[list["UserIdentity"]] = relationship(back_populates="user")
    password_credential: Mapped["UserPasswordCredential | None"] = relationship(
        back_populates="user", uselist=False
    )
    development_sessions: Mapped[list["DevelopmentSession"]] = relationship(back_populates="user")


class UserIdentity(TimestampedModel):
    __tablename__ = "user_identities"
    __table_args__ = (UniqueConstraint("provider", "provider_subject"),)

    user_id: Mapped[str] = mapped_column(ForeignKey("users.id"), index=True)
    provider: Mapped[str] = mapped_column(String(32))
    provider_subject: Mapped[str] = mapped_column(String(320))
    last_authenticated_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True
    )

    user: Mapped[User] = relationship(back_populates="identities")


class UserPasswordCredential(TimestampedModel):
    __tablename__ = "user_password_credentials"

    user_id: Mapped[str] = mapped_column(ForeignKey("users.id"), unique=True, index=True)
    password_hash: Mapped[str] = mapped_column(Text)
    password_changed_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))

    user: Mapped[User] = relationship(back_populates="password_credential")


class DevelopmentSession(TimestampedModel):
    __tablename__ = "development_sessions"

    user_id: Mapped[str] = mapped_column(ForeignKey("users.id"), index=True)
    token_hash: Mapped[str] = mapped_column(String(128), unique=True, index=True)
    expires_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    revoked_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)

    user: Mapped[User] = relationship(back_populates="development_sessions")
