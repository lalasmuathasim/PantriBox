from datetime import UTC, date, datetime

from fastapi.testclient import TestClient

from app.api.v1.household_nutrition import get_household_nutrition_service
from app.domains.nutrition.contracts import (
    HouseholdNutritionInsight,
    NutritionDataCompleteness,
    NutritionReferenceMethodology,
    NutritionSourceProvenance,
)
from app.main import create_app


class FakeHouseholdNutritionInsightService:
    def analyze(
        self, household_id: str, period_start: date, period_end: date
    ) -> HouseholdNutritionInsight:
        return HouseholdNutritionInsight(
            household_id=household_id,
            period_start=period_start,
            period_end=period_end,
            methodology=NutritionReferenceMethodology(
                identifier="india-household-nutrition-reference",
                version="unapproved-v0",
                readiness="not_approved",
                disclaimer="Quantitative adequacy is unavailable.",
            ),
            completeness=NutritionDataCompleteness(
                total_purchase_items=2,
                identified_products=1,
                items_with_nutrition_data=1,
                items_with_usable_quantity=1,
                excluded_missing_product=1,
                excluded_missing_nutrition=0,
                excluded_unsupported_quantity=0,
            ),
            nutrient_totals=(),
            provenance=(
                NutritionSourceProvenance(
                    source="open_food_facts",
                    retrieved_at=datetime(2026, 9, 1, tzinfo=UTC),
                    confidence=None,
                    verification_status="unverified",
                ),
            ),
        )


def test_household_nutrition_endpoint_keeps_purchase_scope_and_methodology_state() -> None:
    app = create_app()
    app.dependency_overrides[get_household_nutrition_service] = FakeHouseholdNutritionInsightService
    response = TestClient(app).get(
        "/api/v1/households/household-1/nutrition-insights",
        params={"period_start": "2026-09-01", "period_end": "2026-09-30"},
    )

    assert response.status_code == 200
    body = response.json()
    assert body["analysis_scope"] == "household_grocery_purchase_coverage"
    assert body["purchase_is_not_consumption"] is True
    assert body["methodology"]["readiness"] == "not_approved"
    assert body["completeness"]["excluded_missing_product"] == 1
