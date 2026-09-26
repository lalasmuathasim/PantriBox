from __future__ import annotations

from collections.abc import Callable
from datetime import UTC, datetime, timedelta

from app.core.errors.exceptions import PantriBoxError
from app.domains.common import BarcodeLookupState
from app.domains.products.contracts import ProductLookupResult
from app.domains.products.repository import ProductLookupRepository
from app.integrations.open_food_facts import ProductDataProviderUnavailableError
from app.services.interfaces import ProductDataProvider


class ProductIntelligenceService:
    def __init__(
        self,
        *,
        repository: ProductLookupRepository,
        provider: ProductDataProvider,
        freshness: timedelta,
        negative_cache_ttl: timedelta,
        now: Callable[[], datetime] = lambda: datetime.now(UTC),
    ) -> None:
        self._repository = repository
        self._provider = provider
        self._freshness = freshness
        self._negative_cache_ttl = negative_cache_ttl
        self._now = now

    def lookup_barcode(self, raw_barcode: str) -> ProductLookupResult:
        barcode = normalize_barcode(raw_barcode)
        now = self._now()
        cached = self._repository.find_by_barcode(barcode)
        if cached is not None and self._is_cache_valid(cached, now):
            return cached.with_state(cached.state, is_cached=True)

        try:
            provider_data = self._provider.lookup_barcode(barcode)
        except ProductDataProviderUnavailableError as exc:
            if cached is not None and cached.product_id is not None:
                return cached.with_state(BarcodeLookupState.STALE, is_cached=True)
            raise PantriBoxError(exc.args[0], status_code=503) from exc

        if provider_data is None:
            if cached is not None and cached.product_id is not None:
                return cached.with_state(BarcodeLookupState.STALE, is_cached=True)
            return self._repository.save_not_found(barcode, now)
        if provider_data.name is None:
            return self._repository.save_incomplete(barcode, now)
        return self._repository.save_provider_product(provider_data, now)

    def _is_cache_valid(self, cached: ProductLookupResult, now: datetime) -> bool:
        if cached.retrieved_at is None:
            return False
        ttl = (
            self._freshness
            if cached.state in (BarcodeLookupState.FOUND, BarcodeLookupState.INCOMPLETE)
            else self._negative_cache_ttl
        )
        return now - cached.retrieved_at <= ttl


def normalize_barcode(raw_barcode: str) -> str:
    barcode = "".join(character for character in raw_barcode if character.isdigit())
    if len(barcode) not in (8, 12, 13, 14):
        raise PantriBoxError("Enter a valid 8, 12, 13, or 14 digit barcode.", status_code=422)
    if not _has_valid_check_digit(barcode):
        raise PantriBoxError("The barcode check digit is invalid.", status_code=422)
    return barcode


def _has_valid_check_digit(barcode: str) -> bool:
    digits = [int(value) for value in barcode]
    check_digit = digits.pop()
    weighted_sum = sum(
        digit * (3 if index % 2 == 0 else 1) for index, digit in enumerate(reversed(digits))
    )
    return (10 - weighted_sum % 10) % 10 == check_digit
