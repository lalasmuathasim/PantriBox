from datetime import timedelta
from typing import Annotated

from fastapi import APIRouter, Depends
from pydantic import BaseModel, Field
from sqlalchemy.orm import Session

from app.core.config.settings import Settings, get_settings
from app.db.session import get_db_session
from app.domains.products.contracts import ProductLookupResult
from app.domains.products.repository import SqlAlchemyProductLookupRepository
from app.integrations.open_food_facts import OpenFoodFactsProvider
from app.services.product_intelligence_service import ProductIntelligenceService

router = APIRouter()


class BarcodeLookupRequest(BaseModel):
    barcode: str = Field(min_length=1, max_length=32)


class NutritionResponse(BaseModel):
    energy_kcal_100g: float | None
    protein_g_100g: float | None
    carbohydrate_g_100g: float | None
    total_sugar_g_100g: float | None
    added_sugar_g_100g: float | None
    fat_g_100g: float | None
    saturated_fat_g_100g: float | None
    trans_fat_g_100g: float | None
    fiber_g_100g: float | None
    sodium_mg_100g: float | None


class IngredientResponse(BaseModel):
    raw_text: str
    canonical_name: str | None
    percentage: float | None
    additive_code: str | None
    functional_purpose: str | None


class BarcodeLookupResponse(BaseModel):
    barcode: str
    state: str
    product_id: str | None
    product_name: str | None
    brand: str | None
    package_quantity: float | None
    package_unit: str | None
    source: str | None
    source_updated_at: str | None
    retrieved_at: str | None
    confidence: float | None
    nutrition: NutritionResponse | None
    ingredients: list[IngredientResponse]
    is_cached: bool


def get_product_intelligence_service(
    db: Annotated[Session, Depends(get_db_session)],
    settings: Annotated[Settings, Depends(get_settings)],
) -> ProductIntelligenceService:
    return ProductIntelligenceService(
        repository=SqlAlchemyProductLookupRepository(db),
        provider=OpenFoodFactsProvider(
            base_url=settings.product_data_provider_base_url,
            user_agent=settings.product_data_provider_user_agent,
            timeout_seconds=settings.product_data_provider_timeout_seconds,
        ),
        freshness=timedelta(hours=settings.product_lookup_freshness_hours),
        negative_cache_ttl=timedelta(hours=settings.product_lookup_negative_cache_hours),
    )


@router.post("/barcode-lookups", response_model=BarcodeLookupResponse)
def lookup_barcode(
    request: BarcodeLookupRequest,
    service: Annotated[ProductIntelligenceService, Depends(get_product_intelligence_service)],
) -> BarcodeLookupResponse:
    return _to_response(service.lookup_barcode(request.barcode))


def _to_response(result: ProductLookupResult) -> BarcodeLookupResponse:
    nutrition = (
        NutritionResponse(
            energy_kcal_100g=result.nutrition.energy_kcal_100g,
            protein_g_100g=result.nutrition.protein_g_100g,
            carbohydrate_g_100g=result.nutrition.carbohydrate_g_100g,
            total_sugar_g_100g=result.nutrition.total_sugar_g_100g,
            added_sugar_g_100g=result.nutrition.added_sugar_g_100g,
            fat_g_100g=result.nutrition.fat_g_100g,
            saturated_fat_g_100g=result.nutrition.saturated_fat_g_100g,
            trans_fat_g_100g=result.nutrition.trans_fat_g_100g,
            fiber_g_100g=result.nutrition.fiber_g_100g,
            sodium_mg_100g=result.nutrition.sodium_mg_100g,
        )
        if result.nutrition is not None
        else None
    )
    return BarcodeLookupResponse(
        barcode=result.barcode,
        state=result.state.value,
        product_id=result.product_id,
        product_name=result.product_name,
        brand=result.brand,
        package_quantity=result.package_quantity,
        package_unit=result.package_unit,
        source=result.source.value if result.source is not None else None,
        source_updated_at=result.source_updated_at.isoformat()
        if result.source_updated_at is not None
        else None,
        retrieved_at=result.retrieved_at.isoformat() if result.retrieved_at is not None else None,
        confidence=result.confidence,
        nutrition=nutrition,
        ingredients=[
            IngredientResponse(
                raw_text=ingredient.raw_text,
                canonical_name=ingredient.canonical_name,
                percentage=ingredient.percentage,
                additive_code=ingredient.additive_code,
                functional_purpose=ingredient.functional_purpose,
            )
            for ingredient in result.ingredients
        ],
        is_cached=result.is_cached,
    )
