from datetime import datetime

from sqlalchemy import DateTime, ForeignKey, String, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.domains.common import (
    ConfidenceColumn,
    ReceiptExtractionStatus,
    ReceiptSource,
    TimestampedModel,
)


class Receipt(TimestampedModel):
    __tablename__ = "receipts"

    household_id: Mapped[str] = mapped_column(ForeignKey("households.id"))
    uploaded_by_user_id: Mapped[str] = mapped_column(ForeignKey("users.id"))
    file_key: Mapped[str | None] = mapped_column(String(255), nullable=True)
    image_url: Mapped[str | None] = mapped_column(String(512), nullable=True)
    raw_ocr_text: Mapped[str | None] = mapped_column(Text, nullable=True)
    captured_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    source: Mapped[str] = mapped_column(String(32), default=ReceiptSource.CAMERA.value)
    extraction_status: Mapped[str] = mapped_column(
        String(32), default=ReceiptExtractionStatus.PENDING.value
    )
    extraction_provider: Mapped[str | None] = mapped_column(String(64), nullable=True)
    extraction_confidence: Mapped[float | None] = mapped_column(ConfidenceColumn, nullable=True)
