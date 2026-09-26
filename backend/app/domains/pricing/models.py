from datetime import datetime

from sqlalchemy import DateTime, ForeignKey, String
from sqlalchemy.orm import Mapped, mapped_column

from app.domains.common import (
    ConfidenceColumn,
    MoneyColumn,
    PriceSource,
    QuantityColumn,
    TimestampedModel,
)


class PriceObservation(TimestampedModel):
    __tablename__ = "price_observations"

    product_id: Mapped[str | None] = mapped_column(ForeignKey("products.id"), nullable=True)
    purchase_item_id: Mapped[str | None] = mapped_column(
        ForeignKey("purchase_items.id"), nullable=True
    )
    store_id: Mapped[str | None] = mapped_column(ForeignKey("stores.id"), nullable=True)
    store_location_id: Mapped[str | None] = mapped_column(
        ForeignKey("store_locations.id"), nullable=True
    )
    raw_description: Mapped[str | None] = mapped_column(String(255), nullable=True)
    quantity: Mapped[float | None] = mapped_column(QuantityColumn, nullable=True)
    unit: Mapped[str | None] = mapped_column(String(32), nullable=True)
    price: Mapped[float] = mapped_column(MoneyColumn)
    unit_price: Mapped[float | None] = mapped_column(MoneyColumn, nullable=True)
    currency: Mapped[str] = mapped_column(String(3), default="INR")
    observed_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=datetime.utcnow)
    source: Mapped[str] = mapped_column(String(32), default=PriceSource.RECEIPT.value)
    confidence: Mapped[float | None] = mapped_column(ConfidenceColumn, nullable=True)
