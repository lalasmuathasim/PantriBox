from fastapi import APIRouter

from app.api.v1.product_intelligence import router as product_intelligence_router
from app.api.v1.system import router as system_router

api_router = APIRouter()
api_router.include_router(system_router, prefix="/system", tags=["system"])
api_router.include_router(
    product_intelligence_router,
    prefix="/product-intelligence",
    tags=["product-intelligence"],
)
