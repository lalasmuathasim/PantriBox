from __future__ import annotations

from dataclasses import dataclass
from datetime import date, datetime

from app.domains.products.contracts import NutritionFacts


@dataclass(frozen=True, slots=True)
class NutritionReferenceMethodology:
    identifier: str
    version: str
    readiness: str
    disclaimer: str


@dataclass(frozen=True, slots=True)
class NutritionSourceProvenance:
    source: str
    retrieved_at: datetime | None
    confidence: float | None
    verification_status: str


@dataclass(frozen=True, slots=True)
class NutritionPurchaseRecord:
    purchase_item_id: str
    purchased_at: datetime
    product_id: str | None
    product_variant_id: str | None
    raw_description: str
    quantity: float | None
    unit: str | None
    nutrition: NutritionFacts | None
    provenance: NutritionSourceProvenance | None


@dataclass(frozen=True, slots=True)
class NutritionDataCompleteness:
    total_purchase_items: int
    identified_products: int
    items_with_nutrition_data: int
    items_with_usable_quantity: int
    excluded_missing_product: int
    excluded_missing_nutrition: int
    excluded_unsupported_quantity: int


@dataclass(frozen=True, slots=True)
class NutrientPurchaseTotal:
    nutrient: str
    unit: str
    value: float
    contributing_item_count: int


@dataclass(frozen=True, slots=True)
class NutritionRecommendationCandidate:
    product_id: str | None
    label: str
    reason: str


@dataclass(frozen=True, slots=True)
class HouseholdNutritionInsight:
    household_id: str
    period_start: date
    period_end: date
    methodology: NutritionReferenceMethodology
    completeness: NutritionDataCompleteness
    nutrient_totals: tuple[NutrientPurchaseTotal, ...]
    provenance: tuple[NutritionSourceProvenance, ...]
    recommendations: tuple[NutritionRecommendationCandidate, ...] = ()

    @property
    def has_purchase_history(self) -> bool:
        return self.completeness.total_purchase_items > 0
