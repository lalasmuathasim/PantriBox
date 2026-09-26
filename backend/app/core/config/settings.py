from functools import lru_cache

from pydantic import Field, field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_prefix="PANTRIBOX_",
        case_sensitive=False,
    )

    env: str = Field(default="development")
    api_name: str = Field(default="PantriBox API")
    api_version: str = Field(default="0.1.0")
    api_host: str = Field(default="0.0.0.0")
    api_port: int = Field(default=8000)
    database_url: str = Field(
        default="postgresql+psycopg://pantribox:pantribox@localhost:5432/pantribox"
    )
    log_level: str = Field(default="INFO")
    allowed_origins: list[str] = Field(default_factory=lambda: ["http://localhost:3000"])
    jwt_audience: str = Field(default="pantribox-mobile")
    jwt_issuer: str = Field(default="pantribox")

    @property
    def is_docs_enabled(self) -> bool:
        return self.env != "production"

    @field_validator("allowed_origins", mode="before")
    @classmethod
    def split_origins(cls, value: str | list[str]) -> list[str]:
        if isinstance(value, str):
            return [item.strip() for item in value.split(",") if item.strip()]
        return value


@lru_cache
def get_settings() -> Settings:
    return Settings()
