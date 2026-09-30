import pytest

from app.scripts.provision_local_database import get_database_target, verify_admin_target


def test_database_target_requires_a_dedicated_role_database_and_password() -> None:
    target = get_database_target(
        "postgresql+psycopg://pantribox_app:local_password@localhost:5432/pantribox"
    )

    assert target.role_name == "pantribox_app"
    assert target.database_name == "pantribox"


def test_database_target_rejects_a_postgres_superuser_connection() -> None:
    with pytest.raises(RuntimeError, match="dedicated application role"):
        get_database_target("postgresql+psycopg://postgres:local_password@localhost:5432/pantribox")


def test_admin_connection_must_use_the_same_server_maintenance_database() -> None:
    target = get_database_target(
        "postgresql+psycopg://pantribox_app:local_password@localhost:5432/pantribox"
    )

    verify_admin_target(
        target.url.set(username="local_admin", password="admin_password", database="postgres"),
        target,
    )
    with pytest.raises(RuntimeError, match="same PostgreSQL server"):
        verify_admin_target(
            target.url.set(host="other-host", username="local_admin", database="postgres"), target
        )
