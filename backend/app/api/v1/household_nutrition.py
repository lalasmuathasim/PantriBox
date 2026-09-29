from __future__ import annotations

from datetime import date, datetime
from typing import Annotated

from fastapi import APIRouter, Depends, Query
from pydantic import BaseModel
from sqlalchemy.orm import Session

from app.db.session import get_db_session
from app.domains.nutrition.contracts import HouseholdNutritionInsight
from app.domains.nutrition.repository import SqlAlchemyNutritionPurchaseRepository
from app.services.household_nutrition_service import (
    HouseholdNutritionInsightService,
    NutritionAggregationService,
    NutritionReferenceService,
)

router = APIRouter()


class NutritionMethodologyResponse(BaseModel):
    identifier: str
    version: str
    readiness: str
    disclaimer: str


class NutritionCompletenessResponse(BaseModel):
    total_purchase_items: int
    identified_products: int
    items_with_nutrition_data: int
    items_with_usable_quantity: int
    excluded_missing_product: int
    excluded_missing_nutrition: int
    excluded_unsupported_quantity: int


class NutrientPurchaseTotalResponse(BaseModel):
    nutrient: str
    unit: str
    value: float
    contributing_item_count: int


class NutritionProvenanceResponse(BaseModel):
    source: str
    retrieved_at: datetime | None
    confidence: float | None
    verification_status: str


class NutritionRecommendationResponse(BaseModel):
    product_id: str | None
    label: str
    reason: str


class HouseholdNutritionInsightResponse(BaseModel):
    household_id: str
    period_start: date
    period_end: date
    analysis_scope: str = "household_grocery_purchase_coverage"
    purchase_is_not_consumption: bool = True
    methodology: NutritionMethodologyResponse
    completeness: NutritionCompletenessResponse
    nutrient_totals: list[NutrientPurchaseTotalResponse]
    provenance: list[NutritionProvenanceResponse]
    recommendations: list[NutritionRecommendationResponse]


def get_household_nutrition_service(
    db: Annotated[Session, Depends(get_db_session)],
) -> HouseholdNutritionInsightService:
    return HouseholdNutritionInsightService(
        repository=SqlAlchemyNutritionPurchaseRepository(db),
        aggregation=NutritionAggregationService(),
        references=NutritionReferenceService(),
    )


@router.get("/{household_id}/nutrition-insights", response_model=HouseholdNutritionInsightResponse)
def get_household_nutrition_insight(
    household_id: str,
    service: Annotated[HouseholdNutritionInsightService, Depends(get_household_nutrition_service)],
    period_start: Annotated[date, Query()],
    period_end: Annotated[date, Query()],
) -> HouseholdNutritionInsightResponse:
    insight = service.analyze(household_id, period_start, period_end)
    return _insight_response(insight)


def _insight_response(insight: HouseholdNutritionInsight) -> HouseholdNutritionInsightResponse:
    return HouseholdNutritionInsightResponse(
        household_id=insight.household_id,
        period_start=insight.period_start,
        period_end=insight.period_end,
        methodology=NutritionMethodologyResponse(
            identifier=insight.methodology.identifier,
            version=insight.methodology.version,
            readiness=insight.methodology.readiness,
            disclaimer=insight.methodology.disclaimer,
        ),
        completeness=NutritionCompletenessResponse(
            total_purchase_items=insight.completeness.total_purchase_items,
            identified_products=insight.completeness.identified_products,
            items_with_nutrition_data=insight.completeness.items_with_nutrition_data,
            items_with_usable_quantity=insight.completeness.items_with_usable_quantity,
            excluded_missing_product=insight.completeness.excluded_missing_product,
            excluded_missing_nutrition=insight.completeness.excluded_missing_nutrition,
            excluded_unsupported_quantity=insight.completeness.excluded_unsupported_quantity,
        ),
        nutrient_totals=[
            NutrientPurchaseTotalResponse(
                nutrient=total.nutrient,
                unit=total.unit,
                value=total.value,
                contributing_item_count=total.contributing_item_count,
            )
            for total in insight.nutrient_totals
        ],
        provenance=[
            NutritionProvenanceResponse(
                source=source.source,
                retrieved_at=source.retrieved_at,
                confidence=source.confidence,
                verification_status=source.verification_status,
            )
            for source in insight.provenance
        ],
        recommendations=[
            NutritionRecommendationResponse(
                product_id=recommendation.product_id,
                label=recommendation.label,
                reason=recommendation.reason,
            )
            for recommendation in insight.recommendations
        ],
    )
