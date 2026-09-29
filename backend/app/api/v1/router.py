from fastapi import APIRouter

from app.api.v1.household_nutrition import router as household_nutrition_router
from app.api.v1.households import router as households_router
from app.api.v1.product_intelligence import router as product_intelligence_router
from app.api.v1.system import router as system_router

api_router = APIRouter()
api_router.include_router(system_router, prefix="/system", tags=["system"])
api_router.include_router(
    product_intelligence_router,
    prefix="/product-intelligence",
    tags=["product-intelligence"],
)
api_router.include_router(households_router, prefix="/households", tags=["households"])
api_router.include_router(
    household_nutrition_router,
    prefix="/households",
    tags=["household-nutrition"],
)
