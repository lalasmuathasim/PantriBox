from datetime import UTC, datetime

from fastapi.testclient import TestClient

from app.api.v1.product_intelligence import get_product_intelligence_service
from app.domains.common import BarcodeLookupState, ProductDataSource
from app.domains.products.contracts import NutritionFacts, ProductLookupResult
from app.main import create_app


class FakeProductIntelligenceService:
    def lookup_barcode(self, barcode: str) -> ProductLookupResult:
        return ProductLookupResult(
            barcode=barcode,
            state=BarcodeLookupState.FOUND,
            product_id="product-1",
            product_name="Example product",
            source=ProductDataSource.OPEN_FOOD_FACTS,
            retrieved_at=datetime(2026, 9, 26, tzinfo=UTC),
            nutrition=NutritionFacts(protein_g_100g=8),
        )


def test_product_intelligence_barcode_lookup_endpoint() -> None:
    app = create_app()
    app.dependency_overrides[get_product_intelligence_service] = FakeProductIntelligenceService
    client = TestClient(app)

    response = client.post(
        "/api/v1/product-intelligence/barcode-lookups",
        json={"barcode": "3017620422003"},
    )

    assert response.status_code == 200
    body = response.json()
    assert body["state"] == "found"
    assert body["product_name"] == "Example product"
    assert body["nutrition"]["protein_g_100g"] == 8
