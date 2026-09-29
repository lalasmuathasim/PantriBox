"""Add household nutrition foundation fields.

Revision ID: 20260929_0002
Revises: 20260926_0001
Create Date: 2026-09-29
"""

import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

from alembic import op

revision = "20260929_0002"
down_revision = "20260926_0001"
branch_labels = None
depends_on = None


def upgrade() -> None:
    uuid = postgresql.UUID(as_uuid=False)
    op.add_column("household_members", sa.Column("date_of_birth", sa.Date(), nullable=True))
    op.add_column("household_members", sa.Column("sex", sa.String(length=16), nullable=True))
    op.add_column(
        "household_members",
        sa.Column("is_active", sa.Boolean(), nullable=False, server_default=sa.true()),
    )
    op.alter_column("household_members", "is_active", server_default=None)
    op.add_column("purchase_items", sa.Column("product_variant_id", uuid, nullable=True))
    op.create_foreign_key(
        "fk_purchase_items_product_variant_id_product_variants",
        "purchase_items",
        "product_variants",
        ["product_variant_id"],
        ["id"],
    )
    op.create_index(
        "ix_purchase_items_product_variant_id",
        "purchase_items",
        ["product_variant_id"],
    )


def downgrade() -> None:
    op.drop_index("ix_purchase_items_product_variant_id", table_name="purchase_items")
    op.drop_constraint(
        "fk_purchase_items_product_variant_id_product_variants",
        "purchase_items",
        type_="foreignkey",
    )
    op.drop_column("purchase_items", "product_variant_id")
    op.drop_column("household_members", "is_active")
    op.drop_column("household_members", "sex")
    op.drop_column("household_members", "date_of_birth")
