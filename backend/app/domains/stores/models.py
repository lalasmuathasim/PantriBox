from sqlalchemy import Float, ForeignKey, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.domains.common import TimestampedModel


class Store(TimestampedModel):
    __tablename__ = "stores"

    name: Mapped[str] = mapped_column(String(160), index=True)


class StoreLocation(TimestampedModel):
    __tablename__ = "store_locations"

    store_id: Mapped[str] = mapped_column(ForeignKey("stores.id"))
    label: Mapped[str | None] = mapped_column(String(120), nullable=True)
    address_line: Mapped[str] = mapped_column(String(255))
    city: Mapped[str | None] = mapped_column(String(120), nullable=True)
    latitude: Mapped[float | None] = mapped_column(Float, nullable=True)
    longitude: Mapped[float | None] = mapped_column(Float, nullable=True)

    store = relationship("Store")
