from dataclasses import dataclass


@dataclass(frozen=True, slots=True)
class UserRoleRecord:
    id: str
    platform_role: str
    account_status: str
    is_active: bool


@dataclass(frozen=True, slots=True)
class DevelopmentUserSeed:
    name: str
    email: str
    password: str
    platform_role: str


@dataclass(frozen=True, slots=True)
class PasswordLoginUser:
    id: str
    email: str
    full_name: str | None
    password_hash: str | None
    platform_role: str
    account_status: str
    is_active: bool
