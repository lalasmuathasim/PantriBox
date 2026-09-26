from __future__ import annotations

import re
from datetime import UTC, datetime
from typing import Any

import httpx

from app.domains.products.contracts import ExternalProductData, IngredientFact, NutritionFacts


class ProductDataProviderUnavailableError(Exception):
    """Raised when an external product provider cannot answer a lookup."""


class OpenFoodFactsProvider:
    _fields = ",".join(
        (
            "code",
            "product_name",
            "brands",
            "quantity",
            "ingredients_text",
            "ingredients",
            "nutriments",
            "last_modified_t",
        )
    )

    def __init__(
        self,
        *,
        base_url: str,
        user_agent: str,
        timeout_seconds: float,
        client: httpx.Client | None = None,
    ) -> None:
        self._base_url = base_url.rstrip("/")
        self._user_agent = user_agent
        self._timeout_seconds = timeout_seconds
        self._client = client

    def lookup_barcode(self, barcode: str) -> ExternalProductData | None:
        client = self._client or httpx.Client()
        owns_client = self._client is None
        try:
            response = client.get(
                f"{self._base_url}/api/v3.6/product/{barcode}",
                params={"fields": self._fields},
                headers={"User-Agent": self._user_agent},
                timeout=self._timeout_seconds,
            )
            response.raise_for_status()
        except httpx.HTTPError as exc:
            raise ProductDataProviderUnavailableError(
                "Product data provider is unavailable."
            ) from exc
        finally:
            if owns_client:
                client.close()

        try:
            payload = response.json()
        except ValueError as exc:
            raise ProductDataProviderUnavailableError(
                "Product data provider returned an invalid response."
            ) from exc
        if not isinstance(payload, dict) or payload.get("status") != 1:
            return None
        product = payload.get("product")
        if not isinstance(product, dict):
            return None
        return _to_external_product_data(barcode, product)


def _to_external_product_data(barcode: str, product: dict[str, Any]) -> ExternalProductData:
    package_quantity, package_unit = _parse_quantity(product.get("quantity"))
    ingredients = _ingredients_from(product)
    nutriments = product.get("nutriments")
    nutrition = _nutrition_from(nutriments) if isinstance(nutriments, dict) else None
    return ExternalProductData(
        barcode=barcode,
        name=_clean_text(product.get("product_name")),
        brand=_first_brand(product.get("brands")),
        package_quantity=package_quantity,
        package_unit=package_unit,
        source_product_id=_clean_text(product.get("code")) or barcode,
        source_updated_at=_timestamp(product.get("last_modified_t")),
        nutrition=nutrition if nutrition is not None and nutrition.has_values else None,
        ingredients=ingredients,
    )


def _nutrition_from(nutriments: dict[str, Any]) -> NutritionFacts:
    sodium_g = _number(nutriments.get("sodium_100g"))
    return NutritionFacts(
        energy_kcal_100g=_number(nutriments.get("energy-kcal_100g")),
        protein_g_100g=_number(nutriments.get("proteins_100g")),
        carbohydrate_g_100g=_number(nutriments.get("carbohydrates_100g")),
        total_sugar_g_100g=_number(nutriments.get("sugars_100g")),
        added_sugar_g_100g=_number(nutriments.get("added-sugars_100g")),
        fat_g_100g=_number(nutriments.get("fat_100g")),
        saturated_fat_g_100g=_number(nutriments.get("saturated-fat_100g")),
        trans_fat_g_100g=_number(nutriments.get("trans-fat_100g")),
        fiber_g_100g=_number(nutriments.get("fiber_100g")),
        sodium_mg_100g=sodium_g * 1000 if sodium_g is not None else None,
    )


def _ingredients_from(product: dict[str, Any]) -> tuple[IngredientFact, ...]:
    raw_ingredients = product.get("ingredients")
    if isinstance(raw_ingredients, list):
        ingredients = tuple(
            IngredientFact(
                raw_text=text,
                canonical_name=_clean_text(item.get("id")),
                percentage=_number(item.get("percent_estimate")),
            )
            for item in raw_ingredients
            if isinstance(item, dict)
            if (text := _clean_text(item.get("text") or item.get("id"))) is not None
        )
        if ingredients:
            return ingredients

    ingredient_text = _clean_text(product.get("ingredients_text"))
    if ingredient_text is None:
        return ()
    return tuple(
        IngredientFact(raw_text=item.strip()) for item in ingredient_text.split(",") if item.strip()
    )


def _parse_quantity(value: Any) -> tuple[float | None, str | None]:
    if not isinstance(value, str):
        return None, None
    match = re.fullmatch(r"\s*(\d+(?:[.,]\d+)?)\s*(kg|g|ml|l)\s*", value.lower())
    if match is None:
        return None, None
    return float(match.group(1).replace(",", ".")), match.group(2)


def _first_brand(value: Any) -> str | None:
    if not isinstance(value, str):
        return None
    return _clean_text(value.split(",", maxsplit=1)[0])


def _clean_text(value: Any) -> str | None:
    if not isinstance(value, str):
        return None
    cleaned = value.strip()
    return cleaned or None


def _number(value: Any) -> float | None:
    if isinstance(value, (int, float)):
        return float(value)
    if isinstance(value, str):
        try:
            return float(value)
        except ValueError:
            return None
    return None


def _timestamp(value: Any) -> datetime | None:
    number = _number(value)
    if number is None:
        return None
    return datetime.fromtimestamp(number, tz=UTC)
