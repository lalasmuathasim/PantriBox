from datetime import UTC, datetime
from typing import Protocol

from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.domains.users.contracts import DevelopmentUserSeed, PasswordLoginUser, UserRoleRecord
from app.domains.users.models import DevelopmentSession, User, UserIdentity, UserPasswordCredential


class UserRoleRepository(Protocol):
    def assign_platform_role(self, user_id: str, platform_role: str) -> UserRoleRecord | None: ...


class SqlAlchemyUserRoleRepository:
    def __init__(self, session: Session) -> None:
        self._session = session

    def assign_platform_role(self, user_id: str, platform_role: str) -> UserRoleRecord | None:
        user = self._session.get(User, user_id)
        if user is None:
            return None
        user.platform_role = platform_role
        self._session.commit()
        self._session.refresh(user)
        return UserRoleRecord(
            id=user.id,
            platform_role=user.platform_role,
            account_status=user.account_status,
            is_active=user.is_active,
        )


class SqlAlchemyDevelopmentAuthenticationRepository:
    def __init__(self, session: Session) -> None:
        self._session = session

    def upsert_development_user(self, seed: DevelopmentUserSeed, password_hash: str) -> None:
        email = seed.email.strip().lower()
        user = self._session.scalar(select(User).where(func.lower(User.email) == email))
        if user is None:
            user = User(email=email)
            self._session.add(user)
            self._session.flush()
        user.full_name = seed.name
        user.platform_role = seed.platform_role
        user.account_status = "active"
        user.is_active = True
        identity = self._session.scalar(
            select(UserIdentity).where(
                UserIdentity.provider == "email", UserIdentity.provider_subject == email
            )
        )
        if identity is None:
            self._session.add(
                UserIdentity(user_id=user.id, provider="email", provider_subject=email)
            )
        credential = self._session.scalar(
            select(UserPasswordCredential).where(UserPasswordCredential.user_id == user.id)
        )
        if credential is None:
            self._session.add(
                UserPasswordCredential(
                    user_id=user.id,
                    password_hash=password_hash,
                    password_changed_at=datetime.now(UTC),
                )
            )
        else:
            credential.password_hash = password_hash
            credential.password_changed_at = datetime.now(UTC)
        self._session.commit()

    def find_by_email(self, email: str) -> PasswordLoginUser | None:
        row = self._session.execute(
            select(User, UserPasswordCredential)
            .outerjoin(UserPasswordCredential, UserPasswordCredential.user_id == User.id)
            .where(func.lower(User.email) == email)
        ).first()
        if row is None:
            return None
        user, credential = row
        return PasswordLoginUser(
            id=user.id,
            email=user.email or "",
            full_name=user.full_name,
            password_hash=credential.password_hash if credential is not None else None,
            platform_role=user.platform_role,
            account_status=user.account_status,
            is_active=user.is_active,
        )

    def create_development_session(
        self, user_id: str, token_hash: str, expires_at: datetime
    ) -> None:
        self._session.add(
            DevelopmentSession(user_id=user_id, token_hash=token_hash, expires_at=expires_at)
        )
        self._session.commit()
