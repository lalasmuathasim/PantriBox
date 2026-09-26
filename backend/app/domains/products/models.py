from datetime import datetime

from sqlalchemy import Boolean, DateTime, Float, ForeignKey, Integer, String, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.domains.common import (
    BarcodeLookupState,
    ConfidenceColumn,
    MeasurementUnit,
    ProductDataSource,
    ProductDataVerificationStatus,
    TimestampedModel,
)


class Product(TimestampedModel):
    __tablename__ = "products"

    name: Mapped[str] = mapped_column(String(160), index=True)
    brand: Mapped[str | None] = mapped_column(String(120), nullable=True)
    default_quantity: Mapped[float | None] = mapped_column(Float, nullable=True)
    default_unit: Mapped[str | None] = mapped_column(String(32), nullable=True)

    variants: Mapped[list["ProductVariant"]] = relationship(back_populates="product")


class ProductAlias(TimestampedModel):
    __tablename__ = "product_aliases"

    product_id: Mapped[str | None] = mapped_column(ForeignKey("products.id"), nullable=True)
    raw_text: Mapped[str] = mapped_column(String(255), index=True)
    normalized_name: Mapped[str | None] = mapped_column(String(160), nullable=True)
    notes: Mapped[str | None] = mapped_column(Text, nullable=True)
    suggested_unit: Mapped[MeasurementUnit | None] = mapped_column(String(32), nullable=True)

    product = relationship("Product")


class ProductVariant(TimestampedModel):
    __tablename__ = "product_variants"

    product_id: Mapped[str] = mapped_column(ForeignKey("products.id"), index=True)
    package_quantity: Mapped[float | None] = mapped_column(Float, nullable=True)
    package_unit: Mapped[str | None] = mapped_column(String(32), nullable=True)
    market: Mapped[str | None] = mapped_column(String(8), nullable=True)

    product: Mapped[Product] = relationship(back_populates="variants")
    barcodes: Mapped[list["ProductBarcode"]] = relationship(back_populates="variant")
    information_snapshots: Mapped[list["ProductInformationSnapshot"]] = relationship(
        back_populates="variant"
    )


class ProductBarcode(TimestampedModel):
    __tablename__ = "product_barcodes"

    normalized_value: Mapped[str] = mapped_column(String(14), unique=True, index=True)
    variant_id: Mapped[str | None] = mapped_column(
        ForeignKey("product_variants.id"), nullable=True, index=True
    )
    last_lookup_state: Mapped[str] = mapped_column(
        String(32), default=BarcodeLookupState.NOT_FOUND.value
    )
    last_looked_up_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True
    )

    variant: Mapped[ProductVariant | None] = relationship(back_populates="barcodes")


class ProductInformationSnapshot(TimestampedModel):
    __tablename__ = "product_information_snapshots"

    variant_id: Mapped[str] = mapped_column(ForeignKey("product_variants.id"), index=True)
    source: Mapped[str] = mapped_column(String(32), default=ProductDataSource.OPEN_FOOD_FACTS.value)
    source_product_id: Mapped[str | None] = mapped_column(String(255), nullable=True)
    source_updated_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True
    )
    retrieved_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=datetime.utcnow)
    confidence: Mapped[float | None] = mapped_column(ConfidenceColumn, nullable=True)
    verification_status: Mapped[str] = mapped_column(
        String(32), default=ProductDataVerificationStatus.UNVERIFIED.value
    )
    is_current: Mapped[bool] = mapped_column(Boolean, default=True, index=True)

    variant: Mapped[ProductVariant] = relationship(back_populates="information_snapshots")
    nutrition: Mapped["ProductNutritionDeclaration | None"] = relationship(
        back_populates="snapshot", uselist=False
    )
    ingredients: Mapped[list["ProductIngredient"]] = relationship(back_populates="snapshot")


class ProductNutritionDeclaration(TimestampedModel):
    __tablename__ = "product_nutrition_declarations"

    snapshot_id: Mapped[str] = mapped_column(
        ForeignKey("product_information_snapshots.id"), unique=True, index=True
    )
    declared_basis_quantity: Mapped[float | None] = mapped_column(Float, nullable=True)
    declared_basis_unit: Mapped[str | None] = mapped_column(String(32), nullable=True)
    energy_kcal: Mapped[float | None] = mapped_column(Float, nullable=True)
    protein_g: Mapped[float | None] = mapped_column(Float, nullable=True)
    carbohydrate_g: Mapped[float | None] = mapped_column(Float, nullable=True)
    total_sugar_g: Mapped[float | None] = mapped_column(Float, nullable=True)
    added_sugar_g: Mapped[float | None] = mapped_column(Float, nullable=True)
    fat_g: Mapped[float | None] = mapped_column(Float, nullable=True)
    saturated_fat_g: Mapped[float | None] = mapped_column(Float, nullable=True)
    trans_fat_g: Mapped[float | None] = mapped_column(Float, nullable=True)
    fiber_g: Mapped[float | None] = mapped_column(Float, nullable=True)
    sodium_mg: Mapped[float | None] = mapped_column(Float, nullable=True)
    energy_kcal_100g: Mapped[float | None] = mapped_column(Float, nullable=True)
    protein_g_100g: Mapped[float | None] = mapped_column(Float, nullable=True)
    carbohydrate_g_100g: Mapped[float | None] = mapped_column(Float, nullable=True)
    total_sugar_g_100g: Mapped[float | None] = mapped_column(Float, nullable=True)
    added_sugar_g_100g: Mapped[float | None] = mapped_column(Float, nullable=True)
    fat_g_100g: Mapped[float | None] = mapped_column(Float, nullable=True)
    saturated_fat_g_100g: Mapped[float | None] = mapped_column(Float, nullable=True)
    trans_fat_g_100g: Mapped[float | None] = mapped_column(Float, nullable=True)
    fiber_g_100g: Mapped[float | None] = mapped_column(Float, nullable=True)
    sodium_mg_100g: Mapped[float | None] = mapped_column(Float, nullable=True)

    snapshot: Mapped[ProductInformationSnapshot] = relationship(back_populates="nutrition")


class ProductIngredient(TimestampedModel):
    __tablename__ = "product_ingredients"

    snapshot_id: Mapped[str] = mapped_column(
        ForeignKey("product_information_snapshots.id"), index=True
    )
    position: Mapped[int] = mapped_column(Integer)
    raw_text: Mapped[str] = mapped_column(Text)
    canonical_name: Mapped[str | None] = mapped_column(String(160), nullable=True)
    percentage: Mapped[float | None] = mapped_column(Float, nullable=True)
    additive_code: Mapped[str | None] = mapped_column(String(32), nullable=True)
    functional_purpose: Mapped[str | None] = mapped_column(String(120), nullable=True)

    snapshot: Mapped[ProductInformationSnapshot] = relationship(back_populates="ingredients")
