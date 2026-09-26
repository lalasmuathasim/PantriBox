from sqlalchemy import Float, ForeignKey, String, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.domains.common import MeasurementUnit, TimestampedModel


class Product(TimestampedModel):
    __tablename__ = "products"

    name: Mapped[str] = mapped_column(String(160), index=True)
    brand: Mapped[str | None] = mapped_column(String(120), nullable=True)
    default_quantity: Mapped[float | None] = mapped_column(Float, nullable=True)
    default_unit: Mapped[str | None] = mapped_column(String(32), nullable=True)


class ProductAlias(TimestampedModel):
    __tablename__ = "product_aliases"

    product_id: Mapped[str | None] = mapped_column(ForeignKey("products.id"), nullable=True)
    raw_text: Mapped[str] = mapped_column(String(255), index=True)
    normalized_name: Mapped[str | None] = mapped_column(String(160), nullable=True)
    notes: Mapped[str | None] = mapped_column(Text, nullable=True)
    suggested_unit: Mapped[MeasurementUnit | None] = mapped_column(String(32), nullable=True)

    product = relationship("Product")
