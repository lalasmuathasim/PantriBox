from datetime import timedelta

import pytest

from app.core.errors.exceptions import PantriBoxError
from app.domains.users.contracts import DevelopmentUserSeed
from app.services.development_authentication_service import (
    DevelopmentAuthenticationService,
    DevelopmentUserSeeder,
    PasswordHasher,
)


class InMemoryDevelopmentAuthenticationRepository:
    def __init__(self) -> None:
        self.users: dict[str, dict[str, object]] = {}
        self.sessions: list[tuple[str, str]] = []

    def upsert_development_user(self, seed, password_hash):
        self.users[seed.email] = {
            "id": seed.email,
            "email": seed.email,
            "full_name": seed.name,
            "password_hash": password_hash,
            "platform_role": seed.platform_role,
            "account_status": "active",
            "is_active": True,
        }

    def find_by_email(self, email):
        from app.domains.users.contracts import PasswordLoginUser

        row = self.users.get(email)
        return PasswordLoginUser(**row) if row is not None else None

    def create_development_session(self, user_id, token_hash, expires_at):
        self.sessions.append((user_id, token_hash))


def test_seed_is_idempotent_and_passwords_are_hashed() -> None:
    repository = InMemoryDevelopmentAuthenticationRepository()
    seed = DevelopmentUserSeed(
        name="Example User",
        email="example@example.com",
        password="not-a-stored-password",
        platform_role="user",
    )
    seeder = DevelopmentUserSeeder(repository, PasswordHasher())

    seeder.seed((seed,))
    seeder.seed((seed,))

    assert list(repository.users) == [seed.email]
    assert repository.users[seed.email]["password_hash"] != seed.password
    assert repository.users[seed.email]["platform_role"] == "user"


def test_login_creates_an_opaque_hashed_session_for_valid_credentials() -> None:
    repository = InMemoryDevelopmentAuthenticationRepository()
    seed = DevelopmentUserSeed(
        name="Example User",
        email="example@example.com",
        password="correct-password",
        platform_role="super_admin",
    )
    hasher = PasswordHasher()
    DevelopmentUserSeeder(repository, hasher).seed((seed,))
    service = DevelopmentAuthenticationService(
        repository, hasher, session_duration=timedelta(hours=1)
    )

    result = service.login(seed.email, seed.password)

    assert result.user.platform_role == "super_admin"
    assert result.access_token
    assert repository.sessions[0][1] != result.access_token


def test_login_rejects_invalid_password() -> None:
    repository = InMemoryDevelopmentAuthenticationRepository()
    seed = DevelopmentUserSeed(
        name="Example User",
        email="example@example.com",
        password="correct-password",
        platform_role="user",
    )
    hasher = PasswordHasher()
    DevelopmentUserSeeder(repository, hasher).seed((seed,))
    service = DevelopmentAuthenticationService(
        repository, hasher, session_duration=timedelta(hours=1)
    )

    with pytest.raises(PantriBoxError, match="incorrect"):
        service.login(seed.email, "wrong-password")
