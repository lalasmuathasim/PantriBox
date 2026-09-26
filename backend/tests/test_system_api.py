from fastapi.testclient import TestClient

from app.main import create_app


def test_health_endpoint() -> None:
    client = TestClient(create_app())

    response = client.get("/api/v1/system/health")

    assert response.status_code == 200
    body = response.json()
    assert body["status"] == "ok"
    assert body["database"]["configured"] is True
    assert "X-Request-ID" in response.headers


def test_version_endpoint() -> None:
    client = TestClient(create_app())

    response = client.get("/api/v1/system/version")

    assert response.status_code == 200
    body = response.json()
    assert body["name"] == "PantriBox API"
    assert body["api_prefix"] == "/api/v1"
    assert isinstance(body["mcp_capabilities"], list)
