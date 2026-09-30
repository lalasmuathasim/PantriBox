import pytest
from pydantic import ValidationError

from app.core.config.settings import Settings


def test_settings_load_with_required_database_url() -> None:
    settings = Settings(
        database_url="postgresql+psycopg://test_user:test_password@localhost:5432/pantribox_test"
    )

    assert settings.api_name == "PantriBox API"
    assert settings.database_url.startswith("postgresql+psycopg://")
    assert settings.is_docs_enabled is True


def test_settings_reject_placeholder_database_url() -> None:
    with pytest.raises(ValidationError, match="must be configured"):
        Settings(
            database_url="postgresql+psycopg://PANTRIBOX_APP_ROLE:CHANGE_ME@localhost:5432/pantribox"
        )


def test_settings_requires_an_explicit_database_url() -> None:
    with pytest.raises(ValidationError, match="database_url"):
        Settings(_env_file=None)
