from __future__ import annotations

from collections import defaultdict
from datetime import date

from app.domains.common import NutritionReferenceReadiness
from app.domains.nutrition.contracts import (
    HouseholdNutritionInsight,
    NutrientPurchaseTotal,
    NutritionDataCompleteness,
    NutritionPurchaseRecord,
    NutritionRecommendationCandidate,
    NutritionReferenceMethodology,
    NutritionSourceProvenance,
)
from app.domains.nutrition.repository import NutritionPurchaseRepository


class NutritionReferenceService:
    """Provides methodology metadata without inventing dietary thresholds."""

    def current_methodology(self) -> NutritionReferenceMethodology:
        return NutritionReferenceMethodology(
            identifier="india-household-nutrition-reference",
            version="unapproved-v0",
            readiness=NutritionReferenceReadiness.NOT_APPROVED.value,
            disclaimer=(
                "Quantitative adequacy is unavailable until an approved Indian nutrition "
                "reference methodology is configured."
            ),
        )


class NutritionAggregationService:
    _nutrients = (
        ("energy_kcal", "kcal", "energy_kcal_100g"),
        ("protein", "g", "protein_g_100g"),
        ("carbohydrate", "g", "carbohydrate_g_100g"),
        ("fibre", "g", "fiber_g_100g"),
        ("sodium", "mg", "sodium_mg_100g"),
    )

    def aggregate(
        self,
        *,
        household_id: str,
        period_start: date,
        period_end: date,
        records: list[NutritionPurchaseRecord],
        methodology: NutritionReferenceMethodology,
    ) -> HouseholdNutritionInsight:
        if period_end < period_start:
            raise ValueError("period_end must not be before period_start")

        total_by_nutrient: dict[str, float] = defaultdict(float)
        contributing_items: dict[str, int] = defaultdict(int)
        sources: dict[tuple[str, object, float | None, str], NutritionSourceProvenance] = {}
        identified = with_nutrition = usable_quantity = 0
        missing_product = missing_nutrition = unsupported_quantity = 0

        for record in records:
            if record.product_id is None:
                missing_product += 1
                continue
            identified += 1
            if record.nutrition is None or not record.nutrition.has_values:
                missing_nutrition += 1
                continue
            with_nutrition += 1
            quantity_grams = _quantity_in_grams(record.quantity, record.unit)
            if quantity_grams is None:
                unsupported_quantity += 1
                continue
            usable_quantity += 1
            if record.provenance is not None:
                sources[
                    (
                        record.provenance.source,
                        record.provenance.retrieved_at,
                        record.provenance.confidence,
                        record.provenance.verification_status,
                    )
                ] = record.provenance
            for name, _unit, field in self._nutrients:
                value_per_100g = getattr(record.nutrition, field)
                if value_per_100g is None:
                    continue
                total_by_nutrient[name] += value_per_100g * quantity_grams / 100
                contributing_items[name] += 1

        totals = tuple(
            NutrientPurchaseTotal(
                nutrient=name,
                unit=unit,
                value=round(total_by_nutrient[name], 2),
                contributing_item_count=contributing_items[name],
            )
            for name, unit, _ in self._nutrients
            if contributing_items[name] > 0
        )
        completeness = NutritionDataCompleteness(
            total_purchase_items=len(records),
            identified_products=identified,
            items_with_nutrition_data=with_nutrition,
            items_with_usable_quantity=usable_quantity,
            excluded_missing_product=missing_product,
            excluded_missing_nutrition=missing_nutrition,
            excluded_unsupported_quantity=unsupported_quantity,
        )
        return HouseholdNutritionInsight(
            household_id=household_id,
            period_start=period_start,
            period_end=period_end,
            methodology=methodology,
            completeness=completeness,
            nutrient_totals=totals,
            provenance=tuple(sources.values()),
        )


class NutritionRecommendationService:
    """Produces candidates only from an approved deterministic methodology."""

    def candidates(
        self, insight: HouseholdNutritionInsight
    ) -> tuple[NutritionRecommendationCandidate, ...]:
        if insight.methodology.readiness != NutritionReferenceReadiness.APPROVED.value:
            return ()
        # An approved food-nutrient relationship dataset belongs here.
        return ()


class HouseholdNutritionInsightService:
    def __init__(
        self,
        *,
        repository: NutritionPurchaseRepository,
        aggregation: NutritionAggregationService,
        references: NutritionReferenceService,
        recommendations: NutritionRecommendationService | None = None,
    ) -> None:
        self._repository = repository
        self._aggregation = aggregation
        self._references = references
        self._recommendations = recommendations or NutritionRecommendationService()

    def analyze(
        self, household_id: str, period_start: date, period_end: date
    ) -> HouseholdNutritionInsight:
        methodology = self._references.current_methodology()
        records = self._repository.list_purchase_records(household_id, period_start, period_end)
        insight = self._aggregation.aggregate(
            household_id=household_id,
            period_start=period_start,
            period_end=period_end,
            records=records,
            methodology=methodology,
        )
        return HouseholdNutritionInsight(
            household_id=insight.household_id,
            period_start=insight.period_start,
            period_end=insight.period_end,
            methodology=insight.methodology,
            completeness=insight.completeness,
            nutrient_totals=insight.nutrient_totals,
            provenance=insight.provenance,
            recommendations=self._recommendations.candidates(insight),
        )


def _quantity_in_grams(quantity: float | None, unit: str | None) -> float | None:
    if quantity is None or quantity <= 0 or unit is None:
        return None
    normalized = unit.strip().lower()
    if normalized in {"g", "gram", "grams"}:
        return quantity
    if normalized in {"kg", "kilogram", "kilograms"}:
        return quantity * 1000
    return None
