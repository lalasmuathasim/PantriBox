from __future__ import annotations

import httpx
import pytest

from app.integrations.open_food_facts import (
    OpenFoodFactsProvider,
    ProductDataProviderUnavailableError,
)


def test_maps_product_response_to_provider_neutral_data() -> None:
    captured_request: httpx.Request | None = None

    def handler(request: httpx.Request) -> httpx.Response:
        nonlocal captured_request
        captured_request = request
        return httpx.Response(
            200,
            json={
                "status": 1,
                "product": {
                    "code": "3017620422003",
                    "product_name": "Chocolate spread",
                    "brands": "Example Brand, Other Brand",
                    "quantity": "350 g",
                    "ingredients": [
                        {"text": "Sugar", "id": "en:sugar", "percent_estimate": 55.0},
                    ],
                    "nutriments": {
                        "energy-kcal_100g": 539,
                        "proteins_100g": 6.3,
                        "sodium_100g": 0.043,
                    },
                    "last_modified_t": 1_700_000_000,
                },
            },
        )

    provider = OpenFoodFactsProvider(
        base_url="https://example.test",
        user_agent="PantriBox-test/1.0 (test@example.com)",
        timeout_seconds=1,
        client=httpx.Client(transport=httpx.MockTransport(handler)),
    )

    product = provider.lookup_barcode("3017620422003")

    assert captured_request is not None
    assert captured_request.url.path == "/api/v3.6/product/3017620422003"
    assert captured_request.headers["user-agent"] == "PantriBox-test/1.0 (test@example.com)"
    assert product is not None
    assert product.name == "Chocolate spread"
    assert product.brand == "Example Brand"
    assert product.package_quantity == 350
    assert product.package_unit == "g"
    assert product.nutrition is not None
    assert product.nutrition.sodium_mg_100g == pytest.approx(43)
    assert product.ingredients[0].canonical_name == "en:sugar"


def test_returns_none_for_unknown_product() -> None:
    provider = OpenFoodFactsProvider(
        base_url="https://example.test",
        user_agent="PantriBox-test/1.0 (test@example.com)",
        timeout_seconds=1,
        client=httpx.Client(
            transport=httpx.MockTransport(lambda _request: httpx.Response(200, json={"status": 0}))
        ),
    )

    assert provider.lookup_barcode("3017620422003") is None


def test_wraps_provider_transport_failure() -> None:
    def handler(request: httpx.Request) -> httpx.Response:
        raise httpx.ConnectError("offline", request=request)

    provider = OpenFoodFactsProvider(
        base_url="https://example.test",
        user_agent="PantriBox-test/1.0 (test@example.com)",
        timeout_seconds=1,
        client=httpx.Client(transport=httpx.MockTransport(handler)),
    )

    with pytest.raises(ProductDataProviderUnavailableError):
        provider.lookup_barcode("3017620422003")


def test_wraps_malformed_provider_response() -> None:
    provider = OpenFoodFactsProvider(
        base_url="https://example.test",
        user_agent="PantriBox-test/1.0 (test@example.com)",
        timeout_seconds=1,
        client=httpx.Client(
            transport=httpx.MockTransport(lambda _request: httpx.Response(200, text="not json"))
        ),
    )

    with pytest.raises(ProductDataProviderUnavailableError):
        provider.lookup_barcode("3017620422003")
