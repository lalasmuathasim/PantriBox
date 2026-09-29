from __future__ import annotations

from datetime import UTC, date, datetime, time, timedelta
from typing import Protocol

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.domains.nutrition.contracts import NutritionPurchaseRecord, NutritionSourceProvenance
from app.domains.products.contracts import NutritionFacts
from app.domains.products.models import (
    ProductInformationSnapshot,
    ProductNutritionDeclaration,
    ProductVariant,
)
from app.domains.purchases.models import Purchase, PurchaseItem


class NutritionPurchaseRepository(Protocol):
    def list_purchase_records(
        self, household_id: str, period_start: date, period_end: date
    ) -> list[NutritionPurchaseRecord]: ...


class SqlAlchemyNutritionPurchaseRepository:
    def __init__(self, session: Session) -> None:
        self._session = session

    def list_purchase_records(
        self, household_id: str, period_start: date, period_end: date
    ) -> list[NutritionPurchaseRecord]:
        start = datetime.combine(period_start, time.min, tzinfo=UTC)
        end = datetime.combine(period_end + timedelta(days=1), time.min, tzinfo=UTC)
        statement = (
            select(PurchaseItem, Purchase)
            .join(Purchase, PurchaseItem.purchase_id == Purchase.id)
            .where(
                Purchase.household_id == household_id,
                Purchase.purchased_at >= start,
                Purchase.purchased_at < end,
            )
            .order_by(Purchase.purchased_at, PurchaseItem.id)
        )
        records: list[NutritionPurchaseRecord] = []
        for item, purchase in self._session.execute(statement):
            snapshot = self._find_current_snapshot(item)
            nutrition = _to_nutrition(snapshot.nutrition) if snapshot is not None else None
            provenance = (
                NutritionSourceProvenance(
                    source=snapshot.source,
                    retrieved_at=snapshot.retrieved_at,
                    confidence=float(snapshot.confidence)
                    if snapshot.confidence is not None
                    else None,
                    verification_status=snapshot.verification_status,
                )
                if snapshot is not None
                else None
            )
            records.append(
                NutritionPurchaseRecord(
                    purchase_item_id=item.id,
                    purchased_at=purchase.purchased_at,
                    product_id=item.product_id,
                    product_variant_id=item.product_variant_id,
                    raw_description=item.raw_description,
                    quantity=float(item.quantity) if item.quantity is not None else None,
                    unit=item.unit,
                    nutrition=nutrition,
                    provenance=provenance,
                )
            )
        return records

    def _find_current_snapshot(self, item: PurchaseItem) -> ProductInformationSnapshot | None:
        statement = select(ProductInformationSnapshot).where(
            ProductInformationSnapshot.is_current.is_(True)
        )
        if item.product_variant_id is not None:
            statement = statement.where(
                ProductInformationSnapshot.variant_id == item.product_variant_id
            )
        elif item.product_id is not None:
            statement = statement.join(ProductVariant).where(
                ProductVariant.product_id == item.product_id
            )
        else:
            return None
        return self._session.scalar(
            statement.order_by(ProductInformationSnapshot.retrieved_at.desc())
        )


def _to_nutrition(nutrition: ProductNutritionDeclaration | None) -> NutritionFacts | None:
    if nutrition is None:
        return None
    facts = NutritionFacts(
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
    return facts if facts.has_values else None
