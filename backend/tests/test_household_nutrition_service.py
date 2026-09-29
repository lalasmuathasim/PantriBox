from datetime import UTC, date, datetime

import pytest

from app.domains.nutrition.contracts import NutritionPurchaseRecord, NutritionSourceProvenance
from app.domains.products.contracts import NutritionFacts
from app.services.household_nutrition_service import (
    NutritionAggregationService,
    NutritionRecommendationService,
    NutritionReferenceService,
)


def _record(
    *,
    identifier: str,
    product_id: str | None = "product-1",
    quantity: float | None = 500,
    unit: str | None = "gram",
    nutrition: NutritionFacts | None = None,
) -> NutritionPurchaseRecord:
    return NutritionPurchaseRecord(
        purchase_item_id=identifier,
        purchased_at=datetime(2026, 9, 10, tzinfo=UTC),
        product_id=product_id,
        product_variant_id="variant-1" if product_id is not None else None,
        raw_description="Example item",
        quantity=quantity,
        unit=unit,
        nutrition=nutrition,
        provenance=NutritionSourceProvenance(
            source="open_food_facts",
            retrieved_at=datetime(2026, 9, 9, tzinfo=UTC),
            confidence=None,
            verification_status="unverified",
        )
        if nutrition is not None
        else None,
    )


def _aggregate(records: list[NutritionPurchaseRecord]):
    return NutritionAggregationService().aggregate(
        household_id="household-1",
        period_start=date(2026, 9, 1),
        period_end=date(2026, 9, 30),
        records=records,
        methodology=NutritionReferenceService().current_methodology(),
    )


def test_aggregates_supported_declared_nutrients_deterministically() -> None:
    nutrition = NutritionFacts(protein_g_100g=10, fiber_g_100g=4)
    records = [
        _record(identifier="item-1", nutrition=nutrition),
        _record(identifier="item-2", quantity=1, unit="kg", nutrition=nutrition),
    ]

    first = _aggregate(records)
    second = _aggregate(records)

    assert first == second
    assert [(total.nutrient, total.value) for total in first.nutrient_totals] == [
        ("protein", 150.0),
        ("fibre", 60.0),
    ]
    assert first.methodology.readiness == "not_approved"
    assert first.has_purchase_history is True
    assert NutritionRecommendationService().candidates(first) == ()


def test_reports_unknown_and_unsupported_purchase_data_without_zeroing_it() -> None:
    records = [
        _record(identifier="missing-product", product_id=None),
        _record(identifier="missing-nutrition", nutrition=None),
        _record(
            identifier="unsupported-unit",
            unit="unit",
            nutrition=NutritionFacts(protein_g_100g=10),
        ),
    ]

    result = _aggregate(records)

    assert result.nutrient_totals == ()
    assert result.completeness.total_purchase_items == 3
    assert result.completeness.identified_products == 2
    assert result.completeness.items_with_nutrition_data == 1
    assert result.completeness.items_with_usable_quantity == 0
    assert result.completeness.excluded_missing_product == 1
    assert result.completeness.excluded_missing_nutrition == 1
    assert result.completeness.excluded_unsupported_quantity == 1


def test_rejects_an_invalid_date_range() -> None:
    with pytest.raises(ValueError, match="period_end"):
        NutritionAggregationService().aggregate(
            household_id="household-1",
            period_start=date(2026, 9, 30),
            period_end=date(2026, 9, 1),
            records=[],
            methodology=NutritionReferenceService().current_methodology(),
        )
