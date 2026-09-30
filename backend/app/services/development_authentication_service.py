from __future__ import annotations

import hashlib
import secrets
from dataclasses import dataclass
from datetime import UTC, datetime, timedelta
from typing import Protocol

from pwdlib import PasswordHash

from app.core.errors.exceptions import PantriBoxError
from app.domains.common import AccountStatus
from app.domains.users.contracts import DevelopmentUserSeed, PasswordLoginUser


@dataclass(frozen=True, slots=True)
class DevelopmentSessionResult:
    access_token: str
    expires_at: datetime
    user: PasswordLoginUser


class DevelopmentAuthenticationRepository(Protocol):
    def upsert_development_user(self, seed: DevelopmentUserSeed, password_hash: str) -> None: ...

    def find_by_email(self, email: str) -> PasswordLoginUser | None: ...

    def create_development_session(
        self, user_id: str, token_hash: str, expires_at: datetime
    ) -> None: ...


class PasswordHasher:
    def __init__(self) -> None:
        self._hasher = PasswordHash.recommended()

    def hash(self, password: str) -> str:
        return self._hasher.hash(password)

    def verify(self, password: str, password_hash: str) -> bool:
        return self._hasher.verify(password, password_hash)


class DevelopmentUserSeeder:
    def __init__(
        self, repository: DevelopmentAuthenticationRepository, hasher: PasswordHasher
    ) -> None:
        self._repository = repository
        self._hasher = hasher

    def seed(self, users: tuple[DevelopmentUserSeed, ...]) -> None:
        for user in users:
            self._repository.upsert_development_user(user, self._hasher.hash(user.password))


class DevelopmentAuthenticationService:
    def __init__(
        self,
        repository: DevelopmentAuthenticationRepository,
        hasher: PasswordHasher,
        *,
        session_duration: timedelta,
    ) -> None:
        self._repository = repository
        self._hasher = hasher
        self._session_duration = session_duration

    def login(self, email: str, password: str) -> DevelopmentSessionResult:
        user = self._repository.find_by_email(email.strip().lower())
        if (
            user is None
            or user.password_hash is None
            or not user.is_active
            or user.account_status != AccountStatus.ACTIVE.value
            or not self._hasher.verify(password, user.password_hash)
        ):
            raise PantriBoxError("Email or password is incorrect.", status_code=401)
        token = secrets.token_urlsafe(32)
        expires_at = datetime.now(UTC) + self._session_duration
        self._repository.create_development_session(user.id, _token_hash(token), expires_at)
        return DevelopmentSessionResult(access_token=token, expires_at=expires_at, user=user)


def _token_hash(token: str) -> str:
    return hashlib.sha256(token.encode()).hexdigest()
