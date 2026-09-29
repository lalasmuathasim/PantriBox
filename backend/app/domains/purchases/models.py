from datetime import datetime

from sqlalchemy import DateTime, ForeignKey, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.domains.common import MoneyColumn, QuantityColumn, TimestampedModel


class Purchase(TimestampedModel):
    __tablename__ = "purchases"

    household_id: Mapped[str] = mapped_column(ForeignKey("households.id"))
    store_id: Mapped[str | None] = mapped_column(ForeignKey("stores.id"), nullable=True)
    store_location_id: Mapped[str | None] = mapped_column(
        ForeignKey("store_locations.id"), nullable=True
    )
    receipt_id: Mapped[str | None] = mapped_column(ForeignKey("receipts.id"), nullable=True)
    purchased_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=datetime.utcnow)
    currency: Mapped[str] = mapped_column(String(3), default="INR")
    total_amount: Mapped[float | None] = mapped_column(MoneyColumn, nullable=True)


class PurchaseItem(TimestampedModel):
    __tablename__ = "purchase_items"

    purchase_id: Mapped[str] = mapped_column(ForeignKey("purchases.id"))
    product_id: Mapped[str | None] = mapped_column(ForeignKey("products.id"), nullable=True)
    product_variant_id: Mapped[str | None] = mapped_column(
        ForeignKey("product_variants.id"), nullable=True
    )
    raw_description: Mapped[str] = mapped_column(String(255))
    quantity: Mapped[float | None] = mapped_column(QuantityColumn, nullable=True)
    unit: Mapped[str | None] = mapped_column(String(32), nullable=True)
    price: Mapped[float] = mapped_column(MoneyColumn)
    unit_price: Mapped[float | None] = mapped_column(MoneyColumn, nullable=True)

    purchase = relationship("Purchase")
