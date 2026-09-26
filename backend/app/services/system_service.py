from app.core.config.settings import get_settings
from app.mcp.registry import McpCapabilityRegistry


class SystemService:
    def get_health(self) -> dict[str, object]:
        settings = get_settings()
        return {
            "status": "ok",
            "application": "PantriBox API",
            "environment": settings.env,
            "database": {
                "configured": bool(settings.database_url),
                "driver": settings.database_url.split("://", maxsplit=1)[0],
            },
        }

    def get_version(self) -> dict[str, object]:
        settings = get_settings()
        registry = McpCapabilityRegistry()
        return {
            "name": settings.api_name,
            "version": settings.api_version,
            "api_prefix": "/api/v1",
            "mcp_capabilities": registry.list_capabilities(),
        }
