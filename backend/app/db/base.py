from sqlalchemy.orm import DeclarativeBase


class Base(DeclarativeBase):
    pass


# Import models so metadata is populated for Alembic and app startup.
from app.domains.households.models import Household, HouseholdMember  # noqa: E402,F401
from app.domains.pricing.models import PriceObservation  # noqa: E402,F401
from app.domains.products.models import Product, ProductAlias  # noqa: E402,F401
from app.domains.purchases.models import Purchase, PurchaseItem  # noqa: E402,F401
from app.domains.receipts.models import Receipt  # noqa: E402,F401
from app.domains.shopping_lists.models import ShoppingList, ShoppingListItem  # noqa: E402,F401
from app.domains.stores.models import Store, StoreLocation  # noqa: E402,F401
from app.domains.users.models import User  # noqa: E402,F401
