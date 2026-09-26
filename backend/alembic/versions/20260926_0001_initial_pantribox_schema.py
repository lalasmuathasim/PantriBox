"""Create the initial PantriBox schema and product intelligence foundation.

Revision ID: 20260926_0001
Revises:
Create Date: 2026-09-26
"""

import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

from alembic import op

revision = "20260926_0001"
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    uuid = postgresql.UUID(as_uuid=False)

    op.create_table(
        "users",
        sa.Column("email", sa.String(length=320), nullable=False),
        sa.Column("full_name", sa.String(length=120), nullable=True),
        sa.Column("is_active", sa.Boolean(), nullable=False),
        sa.Column("id", uuid, nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index("ix_users_email", "users", ["email"], unique=True)

    op.create_table(
        "households",
        sa.Column("name", sa.String(length=120), nullable=False),
        sa.Column("owner_user_id", uuid, nullable=False),
        sa.Column("id", uuid, nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.ForeignKeyConstraint(["owner_user_id"], ["users.id"]),
        sa.PrimaryKeyConstraint("id"),
    )

    op.create_table(
        "stores",
        sa.Column("name", sa.String(length=160), nullable=False),
        sa.Column("id", uuid, nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index("ix_stores_name", "stores", ["name"], unique=False)

    op.create_table(
        "products",
        sa.Column("name", sa.String(length=160), nullable=False),
        sa.Column("brand", sa.String(length=120), nullable=True),
        sa.Column("default_quantity", sa.Float(), nullable=True),
        sa.Column("default_unit", sa.String(length=32), nullable=True),
        sa.Column("id", uuid, nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index("ix_products_name", "products", ["name"], unique=False)

    op.create_table(
        "product_variants",
        sa.Column("product_id", uuid, nullable=False),
        sa.Column("package_quantity", sa.Float(), nullable=True),
        sa.Column("package_unit", sa.String(length=32), nullable=True),
        sa.Column("market", sa.String(length=8), nullable=True),
        sa.Column("id", uuid, nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.ForeignKeyConstraint(["product_id"], ["products.id"]),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index("ix_product_variants_product_id", "product_variants", ["product_id"])

    op.create_table(
        "product_barcodes",
        sa.Column("normalized_value", sa.String(length=14), nullable=False),
        sa.Column("variant_id", uuid, nullable=True),
        sa.Column("last_lookup_state", sa.String(length=32), nullable=False),
        sa.Column("last_looked_up_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("id", uuid, nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.ForeignKeyConstraint(["variant_id"], ["product_variants.id"]),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        "ix_product_barcodes_normalized_value",
        "product_barcodes",
        ["normalized_value"],
        unique=True,
    )
    op.create_index("ix_product_barcodes_variant_id", "product_barcodes", ["variant_id"])

    op.create_table(
        "product_information_snapshots",
        sa.Column("variant_id", uuid, nullable=False),
        sa.Column("source", sa.String(length=32), nullable=False),
        sa.Column("source_product_id", sa.String(length=255), nullable=True),
        sa.Column("source_updated_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("retrieved_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("confidence", sa.Numeric(precision=5, scale=2), nullable=True),
        sa.Column("verification_status", sa.String(length=32), nullable=False),
        sa.Column("is_current", sa.Boolean(), nullable=False),
        sa.Column("id", uuid, nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.ForeignKeyConstraint(["variant_id"], ["product_variants.id"]),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        "ix_product_information_snapshots_variant_id",
        "product_information_snapshots",
        ["variant_id"],
    )
    op.create_index(
        "ix_product_information_snapshots_is_current",
        "product_information_snapshots",
        ["is_current"],
    )

    op.create_table(
        "product_nutrition_declarations",
        sa.Column("snapshot_id", uuid, nullable=False),
        sa.Column("declared_basis_quantity", sa.Float(), nullable=True),
        sa.Column("declared_basis_unit", sa.String(length=32), nullable=True),
        sa.Column("energy_kcal", sa.Float(), nullable=True),
        sa.Column("protein_g", sa.Float(), nullable=True),
        sa.Column("carbohydrate_g", sa.Float(), nullable=True),
        sa.Column("total_sugar_g", sa.Float(), nullable=True),
        sa.Column("added_sugar_g", sa.Float(), nullable=True),
        sa.Column("fat_g", sa.Float(), nullable=True),
        sa.Column("saturated_fat_g", sa.Float(), nullable=True),
        sa.Column("trans_fat_g", sa.Float(), nullable=True),
        sa.Column("fiber_g", sa.Float(), nullable=True),
        sa.Column("sodium_mg", sa.Float(), nullable=True),
        sa.Column("energy_kcal_100g", sa.Float(), nullable=True),
        sa.Column("protein_g_100g", sa.Float(), nullable=True),
        sa.Column("carbohydrate_g_100g", sa.Float(), nullable=True),
        sa.Column("total_sugar_g_100g", sa.Float(), nullable=True),
        sa.Column("added_sugar_g_100g", sa.Float(), nullable=True),
        sa.Column("fat_g_100g", sa.Float(), nullable=True),
        sa.Column("saturated_fat_g_100g", sa.Float(), nullable=True),
        sa.Column("trans_fat_g_100g", sa.Float(), nullable=True),
        sa.Column("fiber_g_100g", sa.Float(), nullable=True),
        sa.Column("sodium_mg_100g", sa.Float(), nullable=True),
        sa.Column("id", uuid, nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.ForeignKeyConstraint(["snapshot_id"], ["product_information_snapshots.id"]),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint("snapshot_id"),
    )
    op.create_index(
        "ix_product_nutrition_declarations_snapshot_id",
        "product_nutrition_declarations",
        ["snapshot_id"],
    )

    op.create_table(
        "product_ingredients",
        sa.Column("snapshot_id", uuid, nullable=False),
        sa.Column("position", sa.Integer(), nullable=False),
        sa.Column("raw_text", sa.Text(), nullable=False),
        sa.Column("canonical_name", sa.String(length=160), nullable=True),
        sa.Column("percentage", sa.Float(), nullable=True),
        sa.Column("additive_code", sa.String(length=32), nullable=True),
        sa.Column("functional_purpose", sa.String(length=120), nullable=True),
        sa.Column("id", uuid, nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.ForeignKeyConstraint(["snapshot_id"], ["product_information_snapshots.id"]),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index("ix_product_ingredients_snapshot_id", "product_ingredients", ["snapshot_id"])

    op.create_table(
        "product_aliases",
        sa.Column("product_id", uuid, nullable=True),
        sa.Column("raw_text", sa.String(length=255), nullable=False),
        sa.Column("normalized_name", sa.String(length=160), nullable=True),
        sa.Column("notes", sa.Text(), nullable=True),
        sa.Column("suggested_unit", sa.String(length=32), nullable=True),
        sa.Column("id", uuid, nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.ForeignKeyConstraint(["product_id"], ["products.id"]),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index("ix_product_aliases_raw_text", "product_aliases", ["raw_text"])

    op.create_table(
        "store_locations",
        sa.Column("store_id", uuid, nullable=False),
        sa.Column("label", sa.String(length=120), nullable=True),
        sa.Column("address_line", sa.String(length=255), nullable=False),
        sa.Column("city", sa.String(length=120), nullable=True),
        sa.Column("latitude", sa.Float(), nullable=True),
        sa.Column("longitude", sa.Float(), nullable=True),
        sa.Column("id", uuid, nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.ForeignKeyConstraint(["store_id"], ["stores.id"]),
        sa.PrimaryKeyConstraint("id"),
    )

    op.create_table(
        "receipts",
        sa.Column("household_id", uuid, nullable=False),
        sa.Column("uploaded_by_user_id", uuid, nullable=False),
        sa.Column("file_key", sa.String(length=255), nullable=True),
        sa.Column("image_url", sa.String(length=512), nullable=True),
        sa.Column("raw_ocr_text", sa.Text(), nullable=True),
        sa.Column("captured_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("id", uuid, nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.ForeignKeyConstraint(["household_id"], ["households.id"]),
        sa.ForeignKeyConstraint(["uploaded_by_user_id"], ["users.id"]),
        sa.PrimaryKeyConstraint("id"),
    )

    op.create_table(
        "purchases",
        sa.Column("household_id", uuid, nullable=False),
        sa.Column("store_id", uuid, nullable=True),
        sa.Column("store_location_id", uuid, nullable=True),
        sa.Column("receipt_id", uuid, nullable=True),
        sa.Column("purchased_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("currency", sa.String(length=3), nullable=False),
        sa.Column("total_amount", sa.Numeric(precision=10, scale=2), nullable=True),
        sa.Column("id", uuid, nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.ForeignKeyConstraint(["household_id"], ["households.id"]),
        sa.ForeignKeyConstraint(["receipt_id"], ["receipts.id"]),
        sa.ForeignKeyConstraint(["store_id"], ["stores.id"]),
        sa.ForeignKeyConstraint(["store_location_id"], ["store_locations.id"]),
        sa.PrimaryKeyConstraint("id"),
    )

    op.create_table(
        "purchase_items",
        sa.Column("purchase_id", uuid, nullable=False),
        sa.Column("product_id", uuid, nullable=True),
        sa.Column("raw_description", sa.String(length=255), nullable=False),
        sa.Column("quantity", sa.Numeric(precision=10, scale=3), nullable=True),
        sa.Column("unit", sa.String(length=32), nullable=True),
        sa.Column("price", sa.Numeric(precision=10, scale=2), nullable=False),
        sa.Column("unit_price", sa.Numeric(precision=10, scale=2), nullable=True),
        sa.Column("id", uuid, nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.ForeignKeyConstraint(["product_id"], ["products.id"]),
        sa.ForeignKeyConstraint(["purchase_id"], ["purchases.id"]),
        sa.PrimaryKeyConstraint("id"),
    )

    op.create_table(
        "price_observations",
        sa.Column("product_id", uuid, nullable=True),
        sa.Column("purchase_item_id", uuid, nullable=True),
        sa.Column("store_id", uuid, nullable=True),
        sa.Column("store_location_id", uuid, nullable=True),
        sa.Column("raw_description", sa.String(length=255), nullable=True),
        sa.Column("quantity", sa.Numeric(precision=10, scale=3), nullable=True),
        sa.Column("unit", sa.String(length=32), nullable=True),
        sa.Column("price", sa.Numeric(precision=10, scale=2), nullable=False),
        sa.Column("unit_price", sa.Numeric(precision=10, scale=2), nullable=True),
        sa.Column("currency", sa.String(length=3), nullable=False),
        sa.Column("observed_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("source", sa.String(length=32), nullable=False),
        sa.Column("confidence", sa.Numeric(precision=5, scale=2), nullable=True),
        sa.Column("id", uuid, nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.ForeignKeyConstraint(["product_id"], ["products.id"]),
        sa.ForeignKeyConstraint(["purchase_item_id"], ["purchase_items.id"]),
        sa.ForeignKeyConstraint(["store_id"], ["stores.id"]),
        sa.ForeignKeyConstraint(["store_location_id"], ["store_locations.id"]),
        sa.PrimaryKeyConstraint("id"),
    )

    op.create_table(
        "shopping_lists",
        sa.Column("household_id", uuid, nullable=False),
        sa.Column("name", sa.String(length=160), nullable=False),
        sa.Column("is_archived", sa.Boolean(), nullable=False),
        sa.Column("id", uuid, nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.ForeignKeyConstraint(["household_id"], ["households.id"]),
        sa.PrimaryKeyConstraint("id"),
    )

    op.create_table(
        "shopping_list_items",
        sa.Column("shopping_list_id", uuid, nullable=False),
        sa.Column("product_id", uuid, nullable=True),
        sa.Column("raw_name", sa.String(length=255), nullable=False),
        sa.Column("quantity", sa.Numeric(precision=10, scale=3), nullable=True),
        sa.Column("unit", sa.String(length=32), nullable=True),
        sa.Column("id", uuid, nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.ForeignKeyConstraint(["product_id"], ["products.id"]),
        sa.ForeignKeyConstraint(["shopping_list_id"], ["shopping_lists.id"]),
        sa.PrimaryKeyConstraint("id"),
    )

    op.create_table(
        "household_members",
        sa.Column("household_id", uuid, nullable=False),
        sa.Column("user_id", uuid, nullable=True),
        sa.Column("display_name", sa.String(length=120), nullable=False),
        sa.Column("id", uuid, nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.ForeignKeyConstraint(["household_id"], ["households.id"]),
        sa.ForeignKeyConstraint(["user_id"], ["users.id"]),
        sa.PrimaryKeyConstraint("id"),
    )


def downgrade() -> None:
    for table_name in (
        "household_members",
        "shopping_list_items",
        "shopping_lists",
        "price_observations",
        "purchase_items",
        "purchases",
        "receipts",
        "store_locations",
        "product_aliases",
        "product_ingredients",
        "product_nutrition_declarations",
        "product_information_snapshots",
        "product_barcodes",
        "product_variants",
        "products",
        "stores",
        "households",
        "users",
    ):
        op.drop_table(table_name)
