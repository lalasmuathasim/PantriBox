from __future__ import annotations

from datetime import datetime
from decimal import Decimal
from enum import StrEnum
from uuid import uuid4

from sqlalchemy import DateTime, ForeignKey, Numeric, String, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column

from app.db.base import Base


class TimestampedModel(Base):
    __abstract__ = True

    id: Mapped[str] = mapped_column(
        UUID(as_uuid=False), primary_key=True, default=lambda: str(uuid4())
    )
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=datetime.utcnow)
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=datetime.utcnow,
        onupdate=datetime.utcnow,
    )


class MeasurementUnit(StrEnum):
    UNIT = "unit"
    GRAM = "gram"
    KILOGRAM = "kilogram"
    MILLILITER = "milliliter"
    LITER = "liter"


class PriceSource(StrEnum):
    RECEIPT = "receipt"
    MANUAL_ENTRY = "manual_entry"
    RETAILER_API = "retailer_api"
    PARTNER_FEED = "partner_feed"
    ONLINE_STORE = "online_store"


class ProductDataSource(StrEnum):
    OPEN_FOOD_FACTS = "open_food_facts"
    LABEL_SCAN = "label_scan"
    OCR = "ocr"
    VISION_MODEL = "vision_model"
    USER_CONFIRMED = "user_confirmed"
    USER_CORRECTED = "user_corrected"
    MANUAL = "manual"


class ProductDataVerificationStatus(StrEnum):
    UNVERIFIED = "unverified"
    MACHINE_EXTRACTED = "machine_extracted"
    USER_CONFIRMED = "user_confirmed"
    USER_CORRECTED = "user_corrected"


class BarcodeLookupState(StrEnum):
    FOUND = "found"
    NOT_FOUND = "not_found"
    INCOMPLETE = "incomplete"
    STALE = "stale"


def id_foreign_key(table_name: str) -> Mapped[str]:
    return mapped_column(ForeignKey(f"{table_name}.id"))


MoneyColumn = Numeric(10, 2)
QuantityColumn = Numeric(10, 3)
ConfidenceColumn = Numeric(5, 2)
ShortTextColumn = String(255)
LongTextColumn = Text()
NullableDecimal = Decimal | None
