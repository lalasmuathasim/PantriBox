from __future__ import annotations

from dataclasses import dataclass
from typing import Protocol

from app.domains.products.contracts import ExternalProductData


class ReceiptStorage(Protocol):
    def store_receipt(self, household_id: str, file_name: str, content_type: str) -> str: ...


class ReceiptExtractor(Protocol):
    def extract_text(self, receipt_reference: str) -> str: ...


class ReceiptParser(Protocol):
    def parse(self, raw_text: str) -> dict[str, object]: ...


class ProductNormalizer(Protocol):
    def normalize(self, raw_description: str) -> dict[str, object]: ...


class ProductDataProvider(Protocol):
    def lookup_barcode(self, barcode: str) -> ExternalProductData | None: ...


class RoutingProvider(Protocol):
    def get_route_summary(self, origin: str, destinations: list[str]) -> dict[str, object]: ...


@dataclass(slots=True)
class ShoppingOptimizationRequest:
    shopping_list_id: str
    max_stores: int
    max_distance_km: float | None = None


class ShoppingOptimizationService(Protocol):
    def optimize(self, request: ShoppingOptimizationRequest) -> dict[str, object]: ...


@dataclass(slots=True)
class ShoppingListRecommendationItem:
    product_id: str | None
    raw_name: str
    reason: str


class ShoppingListRecommendationService(Protocol):
    def add_recommendations(
        self, shopping_list_id: str, items: list[ShoppingListRecommendationItem]
    ) -> None: ...
