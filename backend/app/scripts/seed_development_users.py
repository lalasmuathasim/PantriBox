from app.core.config.settings import get_settings
from app.db.session import SessionLocal
from app.domains.users.contracts import DevelopmentUserSeed
from app.domains.users.repository import SqlAlchemyDevelopmentAuthenticationRepository
from app.services.development_authentication_service import (
    DevelopmentUserSeeder,
    PasswordHasher,
)


def main() -> None:
    settings = get_settings()
    if not settings.is_development_auth_enabled:
        raise RuntimeError("Development user seeding is disabled outside development/test.")
    values = (
        settings.development_seed_super_admin_name,
        settings.development_seed_super_admin_email,
        settings.development_seed_super_admin_password,
        settings.development_seed_normal_user_name,
        settings.development_seed_normal_user_email,
        settings.development_seed_normal_user_password,
    )
    if any(value is None or not value.strip() for value in values):
        raise RuntimeError("Development seed environment variables must all be configured.")
    users = (
        DevelopmentUserSeed(
            name=settings.development_seed_super_admin_name or "",
            email=settings.development_seed_super_admin_email or "",
            password=settings.development_seed_super_admin_password or "",
            platform_role="super_admin",
        ),
        DevelopmentUserSeed(
            name=settings.development_seed_normal_user_name or "",
            email=settings.development_seed_normal_user_email or "",
            password=settings.development_seed_normal_user_password or "",
            platform_role="user",
        ),
    )
    with SessionLocal() as session:
        DevelopmentUserSeeder(
            SqlAlchemyDevelopmentAuthenticationRepository(session), PasswordHasher()
        ).seed(users)
    print("Development users seeded successfully.")


if __name__ == "__main__":
    main()
