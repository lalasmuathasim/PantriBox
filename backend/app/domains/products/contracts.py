from __future__ import annotations

from dataclasses import dataclass, replace
from datetime import datetime

from app.domains.common import BarcodeLookupState, ProductDataSource


@dataclass(frozen=True, slots=True)
class NutritionFacts:
    energy_kcal_100g: float | None = None
    protein_g_100g: float | None = None
    carbohydrate_g_100g: float | None = None
    total_sugar_g_100g: float | None = None
    added_sugar_g_100g: float | None = None
    fat_g_100g: float | None = None
    saturated_fat_g_100g: float | None = None
    trans_fat_g_100g: float | None = None
    fiber_g_100g: float | None = None
    sodium_mg_100g: float | None = None

    @property
    def has_values(self) -> bool:
        return any(
            value is not None
            for value in (
                self.energy_kcal_100g,
                self.protein_g_100g,
                self.carbohydrate_g_100g,
                self.total_sugar_g_100g,
                self.added_sugar_g_100g,
                self.fat_g_100g,
                self.saturated_fat_g_100g,
                self.trans_fat_g_100g,
                self.fiber_g_100g,
                self.sodium_mg_100g,
            )
        )


@dataclass(frozen=True, slots=True)
class IngredientFact:
    raw_text: str
    canonical_name: str | None = None
    percentage: float | None = None
    additive_code: str | None = None
    functional_purpose: str | None = None


@dataclass(frozen=True, slots=True)
class ExternalProductData:
    barcode: str
    name: str | None
    brand: str | None
    package_quantity: float | None
    package_unit: str | None
    source_product_id: str | None
    source_updated_at: datetime | None
    nutrition: NutritionFacts | None
    ingredients: tuple[IngredientFact, ...]
    source: ProductDataSource = ProductDataSource.OPEN_FOOD_FACTS


@dataclass(frozen=True, slots=True)
class ProductLookupResult:
    barcode: str
    state: BarcodeLookupState
    product_id: str | None = None
    product_name: str | None = None
    brand: str | None = None
    package_quantity: float | None = None
    package_unit: str | None = None
    source: ProductDataSource | None = None
    source_updated_at: datetime | None = None
    retrieved_at: datetime | None = None
    confidence: float | None = None
    nutrition: NutritionFacts | None = None
    ingredients: tuple[IngredientFact, ...] = ()
    is_cached: bool = False

    def with_state(self, state: BarcodeLookupState, *, is_cached: bool) -> ProductLookupResult:
        return replace(self, state=state, is_cached=is_cached)
