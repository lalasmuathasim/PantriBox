from __future__ import annotations

from datetime import datetime
from typing import Protocol

from sqlalchemy import select
from sqlalchemy.orm import Session, selectinload

from app.domains.common import (
    BarcodeLookupState,
    ProductDataSource,
    ProductDataVerificationStatus,
)
from app.domains.products.contracts import (
    ExternalProductData,
    IngredientFact,
    NutritionFacts,
    ProductLookupResult,
)
from app.domains.products.models import (
    Product,
    ProductBarcode,
    ProductInformationSnapshot,
    ProductIngredient,
    ProductNutritionDeclaration,
    ProductVariant,
)


class ProductLookupRepository(Protocol):
    def find_by_barcode(self, barcode: str) -> ProductLookupResult | None: ...

    def save_not_found(self, barcode: str, looked_up_at: datetime) -> ProductLookupResult: ...

    def save_incomplete(self, barcode: str, looked_up_at: datetime) -> ProductLookupResult: ...

    def save_provider_product(
        self, product_data: ExternalProductData, looked_up_at: datetime
    ) -> ProductLookupResult: ...


class SqlAlchemyProductLookupRepository:
    def __init__(self, session: Session) -> None:
        self._session = session

    def find_by_barcode(self, barcode: str) -> ProductLookupResult | None:
        barcode_record = self._get_barcode_record(barcode)
        if barcode_record is None:
            return None
        return self._to_result(barcode_record)

    def save_not_found(self, barcode: str, looked_up_at: datetime) -> ProductLookupResult:
        return self._save_non_product_result(barcode, BarcodeLookupState.NOT_FOUND, looked_up_at)

    def save_incomplete(self, barcode: str, looked_up_at: datetime) -> ProductLookupResult:
        return self._save_non_product_result(barcode, BarcodeLookupState.INCOMPLETE, looked_up_at)

    def save_provider_product(
        self, product_data: ExternalProductData, looked_up_at: datetime
    ) -> ProductLookupResult:
        barcode_record = self._get_barcode_record(product_data.barcode)
        if barcode_record is None:
            barcode_record = ProductBarcode(normalized_value=product_data.barcode)
            self._session.add(barcode_record)

        if barcode_record.variant is None:
            product = Product(
                name=product_data.name or product_data.barcode,
                brand=product_data.brand,
                default_quantity=product_data.package_quantity,
                default_unit=product_data.package_unit,
            )
            variant = ProductVariant(
                product=product,
                package_quantity=product_data.package_quantity,
                package_unit=product_data.package_unit,
            )
            barcode_record.variant = variant
            self._session.add_all([product, variant])

        variant = barcode_record.variant
        assert variant is not None
        for snapshot in variant.information_snapshots:
            snapshot.is_current = False

        snapshot = ProductInformationSnapshot(
            variant=variant,
            source=product_data.source.value,
            source_product_id=product_data.source_product_id,
            source_updated_at=product_data.source_updated_at,
            retrieved_at=looked_up_at,
            verification_status=ProductDataVerificationStatus.UNVERIFIED.value,
            is_current=True,
        )
        self._session.add(snapshot)

        if product_data.nutrition is not None and product_data.nutrition.has_values:
            self._session.add(_nutrition_declaration(snapshot, product_data.nutrition))

        self._session.add_all(
            ProductIngredient(
                snapshot=snapshot,
                position=index,
                raw_text=ingredient.raw_text,
                canonical_name=ingredient.canonical_name,
                percentage=ingredient.percentage,
                additive_code=ingredient.additive_code,
                functional_purpose=ingredient.functional_purpose,
            )
            for index, ingredient in enumerate(product_data.ingredients, start=1)
        )

        barcode_record.last_lookup_state = (
            BarcodeLookupState.FOUND.value
            if product_data.nutrition is not None or product_data.ingredients
            else BarcodeLookupState.INCOMPLETE.value
        )
        barcode_record.last_looked_up_at = looked_up_at
        self._session.commit()
        self._session.refresh(barcode_record)
        return self._to_result(barcode_record)

    def _save_non_product_result(
        self, barcode: str, state: BarcodeLookupState, looked_up_at: datetime
    ) -> ProductLookupResult:
        barcode_record = self._get_barcode_record(barcode)
        if barcode_record is None:
            barcode_record = ProductBarcode(normalized_value=barcode)
            self._session.add(barcode_record)
        barcode_record.last_lookup_state = state.value
        barcode_record.last_looked_up_at = looked_up_at
        self._session.commit()
        self._session.refresh(barcode_record)
        return self._to_result(barcode_record)

    def _get_barcode_record(self, barcode: str) -> ProductBarcode | None:
        statement = (
            select(ProductBarcode)
            .where(ProductBarcode.normalized_value == barcode)
            .options(
                selectinload(ProductBarcode.variant).selectinload(ProductVariant.product),
                selectinload(ProductBarcode.variant)
                .selectinload(ProductVariant.information_snapshots)
                .selectinload(ProductInformationSnapshot.nutrition),
                selectinload(ProductBarcode.variant)
                .selectinload(ProductVariant.information_snapshots)
                .selectinload(ProductInformationSnapshot.ingredients),
            )
        )
        return self._session.scalar(statement)

    def _to_result(self, barcode_record: ProductBarcode) -> ProductLookupResult:
        try:
            state = BarcodeLookupState(barcode_record.last_lookup_state)
        except ValueError:
            state = BarcodeLookupState.INCOMPLETE

        variant = barcode_record.variant
        if variant is None:
            return ProductLookupResult(
                barcode=barcode_record.normalized_value,
                state=state,
                retrieved_at=barcode_record.last_looked_up_at,
            )

        snapshot = next(
            (item for item in variant.information_snapshots if item.is_current),
            None,
        )
        if snapshot is None:
            return ProductLookupResult(
                barcode=barcode_record.normalized_value,
                state=BarcodeLookupState.INCOMPLETE,
                product_id=variant.product_id,
                product_name=variant.product.name,
                brand=variant.product.brand,
                package_quantity=variant.package_quantity,
                package_unit=variant.package_unit,
                retrieved_at=barcode_record.last_looked_up_at,
            )

        nutrition = _nutrition_facts(snapshot.nutrition)
        ingredients = tuple(
            IngredientFact(
                raw_text=ingredient.raw_text,
                canonical_name=ingredient.canonical_name,
                percentage=ingredient.percentage,
                additive_code=ingredient.additive_code,
                functional_purpose=ingredient.functional_purpose,
            )
            for ingredient in sorted(snapshot.ingredients, key=lambda item: item.position)
        )
        try:
            source = ProductDataSource(snapshot.source)
        except ValueError:
            source = None

        return ProductLookupResult(
            barcode=barcode_record.normalized_value,
            state=state,
            product_id=variant.product_id,
            product_name=variant.product.name,
            brand=variant.product.brand,
            package_quantity=variant.package_quantity,
            package_unit=variant.package_unit,
            source=source,
            source_updated_at=snapshot.source_updated_at,
            retrieved_at=snapshot.retrieved_at,
            confidence=snapshot.confidence,
            nutrition=nutrition,
            ingredients=ingredients,
        )


def _nutrition_declaration(
    snapshot: ProductInformationSnapshot, nutrition: NutritionFacts
) -> ProductNutritionDeclaration:
    return ProductNutritionDeclaration(
        snapshot=snapshot,
        energy_kcal_100g=nutrition.energy_kcal_100g,
        protein_g_100g=nutrition.protein_g_100g,
        carbohydrate_g_100g=nutrition.carbohydrate_g_100g,
        total_sugar_g_100g=nutrition.total_sugar_g_100g,
        added_sugar_g_100g=nutrition.added_sugar_g_100g,
        fat_g_100g=nutrition.fat_g_100g,
        saturated_fat_g_100g=nutrition.saturated_fat_g_100g,
        trans_fat_g_100g=nutrition.trans_fat_g_100g,
        fiber_g_100g=nutrition.fiber_g_100g,
        sodium_mg_100g=nutrition.sodium_mg_100g,
    )


def _nutrition_facts(nutrition: ProductNutritionDeclaration | None) -> NutritionFacts | None:
    if nutrition is None:
        return None
    return NutritionFacts(
        energy_kcal_100g=nutrition.energy_kcal_100g,
        protein_g_100g=nutrition.protein_g_100g,
        carbohydrate_g_100g=nutrition.carbohydrate_g_100g,
        total_sugar_g_100g=nutrition.total_sugar_g_100g,
        added_sugar_g_100g=nutrition.added_sugar_g_100g,
        fat_g_100g=nutrition.fat_g_100g,
        saturated_fat_g_100g=nutrition.saturated_fat_g_100g,
        trans_fat_g_100g=nutrition.trans_fat_g_100g,
        fiber_g_100g=nutrition.fiber_g_100g,
        sodium_mg_100g=nutrition.sodium_mg_100g,
    )
