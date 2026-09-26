from __future__ import annotations

from datetime import UTC, datetime, timedelta

import pytest

from app.core.errors.exceptions import PantriBoxError
from app.domains.common import BarcodeLookupState
from app.domains.products.contracts import ExternalProductData, ProductLookupResult
from app.integrations.open_food_facts import ProductDataProviderUnavailableError
from app.services.product_intelligence_service import ProductIntelligenceService, normalize_barcode


class InMemoryProductLookupRepository:
    def __init__(self) -> None:
        self.results: dict[str, ProductLookupResult] = {}

    def find_by_barcode(self, barcode: str) -> ProductLookupResult | None:
        return self.results.get(barcode)

    def save_not_found(self, barcode: str, looked_up_at: datetime) -> ProductLookupResult:
        result = ProductLookupResult(
            barcode=barcode,
            state=BarcodeLookupState.NOT_FOUND,
            retrieved_at=looked_up_at,
        )
        self.results[barcode] = result
        return result

    def save_incomplete(self, barcode: str, looked_up_at: datetime) -> ProductLookupResult:
        result = ProductLookupResult(
            barcode=barcode,
            state=BarcodeLookupState.INCOMPLETE,
            retrieved_at=looked_up_at,
        )
        self.results[barcode] = result
        return result

    def save_provider_product(
        self, product_data: ExternalProductData, looked_up_at: datetime
    ) -> ProductLookupResult:
        result = ProductLookupResult(
            barcode=product_data.barcode,
            state=BarcodeLookupState.FOUND,
            product_id="product-1",
            product_name=product_data.name,
            brand=product_data.brand,
            package_quantity=product_data.package_quantity,
            package_unit=product_data.package_unit,
            source=product_data.source,
            source_updated_at=product_data.source_updated_at,
            retrieved_at=looked_up_at,
            nutrition=product_data.nutrition,
            ingredients=product_data.ingredients,
        )
        self.results[product_data.barcode] = result
        return result


class StaticProvider:
    def __init__(self, result: ExternalProductData | None = None, *, fails: bool = False) -> None:
        self.result = result
        self.fails = fails
        self.calls = 0

    def lookup_barcode(self, barcode: str) -> ExternalProductData | None:
        self.calls += 1
        if self.fails:
            raise ProductDataProviderUnavailableError("Provider unavailable")
        return self.result


def _service(
    repository: InMemoryProductLookupRepository,
    provider: StaticProvider,
    now: datetime,
) -> ProductIntelligenceService:
    return ProductIntelligenceService(
        repository=repository,
        provider=provider,
        freshness=timedelta(days=30),
        negative_cache_ttl=timedelta(hours=24),
        now=lambda: now,
    )


def test_returns_fresh_cached_product_without_provider_call() -> None:
    now = datetime(2026, 9, 26, tzinfo=UTC)
    repository = InMemoryProductLookupRepository()
    repository.results["3017620422003"] = ProductLookupResult(
        barcode="3017620422003",
        state=BarcodeLookupState.FOUND,
        product_id="product-1",
        product_name="Cached product",
        retrieved_at=now - timedelta(days=2),
    )
    provider = StaticProvider()

    result = _service(repository, provider, now).lookup_barcode("3017620422003")

    assert result.is_cached is True
    assert result.product_name == "Cached product"
    assert provider.calls == 0


def test_uses_stale_product_when_provider_is_unavailable() -> None:
    now = datetime(2026, 9, 26, tzinfo=UTC)
    repository = InMemoryProductLookupRepository()
    repository.results["3017620422003"] = ProductLookupResult(
        barcode="3017620422003",
        state=BarcodeLookupState.FOUND,
        product_id="product-1",
        product_name="Cached product",
        retrieved_at=now - timedelta(days=31),
    )

    result = _service(repository, StaticProvider(fails=True), now).lookup_barcode("3017620422003")

    assert result.state == BarcodeLookupState.STALE
    assert result.is_cached is True


def test_records_unknown_barcode() -> None:
    now = datetime(2026, 9, 26, tzinfo=UTC)
    repository = InMemoryProductLookupRepository()

    result = _service(repository, StaticProvider(), now).lookup_barcode("3017620422003")

    assert result.state == BarcodeLookupState.NOT_FOUND
    assert result.is_cached is False


@pytest.mark.parametrize("raw_barcode", ["", "1234567", "1234567890123", "abc"])
def test_rejects_invalid_barcodes(raw_barcode: str) -> None:
    with pytest.raises(PantriBoxError) as error:
        normalize_barcode(raw_barcode)

    assert error.value.status_code == 422


def test_normalizes_separators_without_changing_valid_barcode() -> None:
    assert normalize_barcode("3017-6204 22003") == "3017620422003"
