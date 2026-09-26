from sqlalchemy import Boolean, ForeignKey, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.domains.common import QuantityColumn, TimestampedModel


class ShoppingList(TimestampedModel):
    __tablename__ = "shopping_lists"

    household_id: Mapped[str] = mapped_column(ForeignKey("households.id"))
    name: Mapped[str] = mapped_column(String(160))
    is_archived: Mapped[bool] = mapped_column(Boolean, default=False)


class ShoppingListItem(TimestampedModel):
    __tablename__ = "shopping_list_items"

    shopping_list_id: Mapped[str] = mapped_column(ForeignKey("shopping_lists.id"))
    product_id: Mapped[str | None] = mapped_column(ForeignKey("products.id"), nullable=True)
    raw_name: Mapped[str] = mapped_column(String(255))
    quantity: Mapped[float | None] = mapped_column(QuantityColumn, nullable=True)
    unit: Mapped[str | None] = mapped_column(String(32), nullable=True)

    shopping_list = relationship("ShoppingList")
