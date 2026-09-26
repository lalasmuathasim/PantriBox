from app.core.config.settings import Settings


def test_settings_load_with_defaults() -> None:
    settings = Settings()

    assert settings.api_name == "PantriBox API"
    assert settings.database_url.startswith("postgresql+psycopg://")
    assert settings.is_docs_enabled is True
