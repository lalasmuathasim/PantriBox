"""Harden identity, household access, provenance, and audit foundations.

Revision ID: 20260929_0003
Revises: 20260929_0002
Create Date: 2026-09-29
"""

import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

from alembic import op

revision = "20260929_0003"
down_revision = "20260929_0002"
branch_labels = None
depends_on = None


def upgrade() -> None:
    uuid = postgresql.UUID(as_uuid=False)

    op.alter_column("users", "email", existing_type=sa.String(length=320), nullable=True)
    op.add_column(
        "users", sa.Column("email_verified_at", sa.DateTime(timezone=True), nullable=True)
    )
    op.add_column("users", sa.Column("mobile_e164", sa.String(length=32), nullable=True))
    op.add_column(
        "users", sa.Column("mobile_verified_at", sa.DateTime(timezone=True), nullable=True)
    )
    op.add_column(
        "users",
        sa.Column("account_status", sa.String(length=32), nullable=False, server_default="active"),
    )
    op.add_column(
        "users",
        sa.Column("platform_role", sa.String(length=32), nullable=False, server_default="user"),
    )
    op.alter_column("users", "account_status", server_default=None)
    op.alter_column("users", "platform_role", server_default=None)
    op.create_index("ix_users_mobile_e164", "users", ["mobile_e164"], unique=True)

    op.create_table(
        "user_identities",
        sa.Column("user_id", uuid, nullable=False),
        sa.Column("provider", sa.String(length=32), nullable=False),
        sa.Column("provider_subject", sa.String(length=320), nullable=False),
        sa.Column("last_authenticated_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("id", uuid, nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.ForeignKeyConstraint(["user_id"], ["users.id"]),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint("provider", "provider_subject"),
    )
    op.create_index("ix_user_identities_user_id", "user_identities", ["user_id"])
    op.execute(
        """
        INSERT INTO user_identities (
            id, user_id, provider, provider_subject, created_at, updated_at
        )
        SELECT
            md5(random()::text || clock_timestamp()::text || u.id::text)::uuid,
            u.id,
            'email',
            u.email,
            u.created_at,
            u.updated_at
        FROM users AS u
        WHERE u.email IS NOT NULL
        """
    )

    op.create_table(
        "household_memberships",
        sa.Column("household_id", uuid, nullable=False),
        sa.Column("user_id", uuid, nullable=False),
        sa.Column("role", sa.String(length=32), nullable=False),
        sa.Column("is_active", sa.Boolean(), nullable=False),
        sa.Column("id", uuid, nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.ForeignKeyConstraint(["household_id"], ["households.id"]),
        sa.ForeignKeyConstraint(["user_id"], ["users.id"]),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint("household_id", "user_id"),
    )
    op.create_index(
        "ix_household_memberships_household_id", "household_memberships", ["household_id"]
    )
    op.create_index("ix_household_memberships_user_id", "household_memberships", ["user_id"])
    op.execute(
        """
        INSERT INTO household_memberships (
            id, household_id, user_id, role, is_active, created_at, updated_at
        )
        SELECT
            md5(random()::text || clock_timestamp()::text || h.id::text)::uuid,
            h.id,
            h.owner_user_id,
            'owner',
            true,
            h.created_at,
            h.updated_at
        FROM households AS h
        """
    )

    op.create_table(
        "household_invitations",
        sa.Column("household_id", uuid, nullable=False),
        sa.Column("invitee_email", sa.String(length=320), nullable=False),
        sa.Column("role", sa.String(length=32), nullable=False),
        sa.Column("status", sa.String(length=32), nullable=False),
        sa.Column("token_hash", sa.String(length=255), nullable=False),
        sa.Column("expires_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("invited_by_user_id", uuid, nullable=False),
        sa.Column("accepted_by_user_id", uuid, nullable=True),
        sa.Column("id", uuid, nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.ForeignKeyConstraint(["accepted_by_user_id"], ["users.id"]),
        sa.ForeignKeyConstraint(["household_id"], ["households.id"]),
        sa.ForeignKeyConstraint(["invited_by_user_id"], ["users.id"]),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint("token_hash"),
    )
    op.create_index(
        "ix_household_invitations_household_id", "household_invitations", ["household_id"]
    )
    op.create_index(
        "ix_household_invitations_invitee_email", "household_invitations", ["invitee_email"]
    )
    op.create_index("ix_household_invitations_status", "household_invitations", ["status"])
    op.create_unique_constraint(
        "uq_household_members_household_user", "household_members", ["household_id", "user_id"]
    )

    op.add_column(
        "receipts",
        sa.Column("source", sa.String(length=32), nullable=False, server_default="camera"),
    )
    op.add_column(
        "receipts",
        sa.Column(
            "extraction_status", sa.String(length=32), nullable=False, server_default="pending"
        ),
    )
    op.add_column("receipts", sa.Column("extraction_provider", sa.String(length=64), nullable=True))
    op.add_column(
        "receipts",
        sa.Column("extraction_confidence", sa.Numeric(precision=5, scale=2), nullable=True),
    )
    op.alter_column("receipts", "source", server_default=None)
    op.alter_column("receipts", "extraction_status", server_default=None)
    op.create_index(
        "ix_receipts_household_captured_at", "receipts", ["household_id", "captured_at"]
    )

    op.add_column("purchases", sa.Column("recorded_by_user_id", uuid, nullable=True))
    op.add_column(
        "purchases",
        sa.Column("source", sa.String(length=32), nullable=False, server_default="receipt"),
    )
    op.create_foreign_key(
        "fk_purchases_recorded_by_user_id_users",
        "purchases",
        "users",
        ["recorded_by_user_id"],
        ["id"],
    )
    op.alter_column("purchases", "source", server_default=None)
    op.create_index(
        "ix_purchases_household_purchased_at", "purchases", ["household_id", "purchased_at"]
    )

    op.add_column("purchase_items", sa.Column("match_source", sa.String(length=32), nullable=True))
    op.add_column(
        "purchase_items",
        sa.Column("match_confidence", sa.Numeric(precision=5, scale=2), nullable=True),
    )
    op.add_column("purchase_items", sa.Column("matched_by_user_id", uuid, nullable=True))
    op.add_column(
        "purchase_items", sa.Column("source_line_reference", sa.String(length=120), nullable=True)
    )
    op.create_foreign_key(
        "fk_purchase_items_matched_by_user_id_users",
        "purchase_items",
        "users",
        ["matched_by_user_id"],
        ["id"],
    )
    op.create_index("ix_purchase_items_purchase_id", "purchase_items", ["purchase_id"])
    op.create_index("ix_purchase_items_product_id", "purchase_items", ["product_id"])

    op.add_column("price_observations", sa.Column("product_variant_id", uuid, nullable=True))
    op.create_foreign_key(
        "fk_price_observations_product_variant_id_product_variants",
        "price_observations",
        "product_variants",
        ["product_variant_id"],
        ["id"],
    )
    op.create_index(
        "ix_price_observations_product_variant_observed_at",
        "price_observations",
        ["product_variant_id", "observed_at"],
    )
    op.create_index(
        "ix_price_observations_product_observed_at",
        "price_observations",
        ["product_id", "observed_at"],
    )
    op.create_index(
        "ix_price_observations_store_location_observed_at",
        "price_observations",
        ["store_location_id", "observed_at"],
    )
    op.create_index(
        "ix_shopping_lists_household_archived", "shopping_lists", ["household_id", "is_archived"]
    )

    op.create_table(
        "audit_events",
        sa.Column("actor_user_id", uuid, nullable=True),
        sa.Column("household_id", uuid, nullable=True),
        sa.Column("event_type", sa.String(length=120), nullable=False),
        sa.Column("resource_type", sa.String(length=80), nullable=False),
        sa.Column("resource_id", sa.String(length=64), nullable=True),
        sa.Column("details", postgresql.JSONB(astext_type=sa.Text()), nullable=True),
        sa.Column("id", uuid, nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.ForeignKeyConstraint(["actor_user_id"], ["users.id"]),
        sa.ForeignKeyConstraint(["household_id"], ["households.id"]),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index("ix_audit_events_actor_user_id", "audit_events", ["actor_user_id"])
    op.create_index("ix_audit_events_household_id", "audit_events", ["household_id"])
    op.create_index("ix_audit_events_event_type", "audit_events", ["event_type"])


def downgrade() -> None:
    op.drop_index("ix_audit_events_event_type", table_name="audit_events")
    op.drop_index("ix_audit_events_household_id", table_name="audit_events")
    op.drop_index("ix_audit_events_actor_user_id", table_name="audit_events")
    op.drop_table("audit_events")

    op.drop_index("ix_shopping_lists_household_archived", table_name="shopping_lists")
    op.drop_index(
        "ix_price_observations_store_location_observed_at", table_name="price_observations"
    )
    op.drop_index("ix_price_observations_product_observed_at", table_name="price_observations")
    op.drop_index(
        "ix_price_observations_product_variant_observed_at", table_name="price_observations"
    )
    op.drop_constraint(
        "fk_price_observations_product_variant_id_product_variants",
        "price_observations",
        type_="foreignkey",
    )
    op.drop_column("price_observations", "product_variant_id")

    op.drop_index("ix_purchase_items_product_id", table_name="purchase_items")
    op.drop_index("ix_purchase_items_purchase_id", table_name="purchase_items")
    op.drop_constraint(
        "fk_purchase_items_matched_by_user_id_users", "purchase_items", type_="foreignkey"
    )
    op.drop_column("purchase_items", "source_line_reference")
    op.drop_column("purchase_items", "matched_by_user_id")
    op.drop_column("purchase_items", "match_confidence")
    op.drop_column("purchase_items", "match_source")

    op.drop_index("ix_purchases_household_purchased_at", table_name="purchases")
    op.drop_constraint("fk_purchases_recorded_by_user_id_users", "purchases", type_="foreignkey")
    op.drop_column("purchases", "source")
    op.drop_column("purchases", "recorded_by_user_id")

    op.drop_index("ix_receipts_household_captured_at", table_name="receipts")
    op.drop_column("receipts", "extraction_confidence")
    op.drop_column("receipts", "extraction_provider")
    op.drop_column("receipts", "extraction_status")
    op.drop_column("receipts", "source")

    op.drop_constraint("uq_household_members_household_user", "household_members", type_="unique")
    op.drop_index("ix_household_invitations_status", table_name="household_invitations")
    op.drop_index("ix_household_invitations_invitee_email", table_name="household_invitations")
    op.drop_index("ix_household_invitations_household_id", table_name="household_invitations")
    op.drop_table("household_invitations")
    op.drop_index("ix_household_memberships_user_id", table_name="household_memberships")
    op.drop_index("ix_household_memberships_household_id", table_name="household_memberships")
    op.drop_table("household_memberships")
    op.drop_index("ix_user_identities_user_id", table_name="user_identities")
    op.drop_table("user_identities")
    op.drop_index("ix_users_mobile_e164", table_name="users")
    op.drop_column("users", "platform_role")
    op.drop_column("users", "account_status")
    op.drop_column("users", "mobile_verified_at")
    op.drop_column("users", "mobile_e164")
    op.drop_column("users", "email_verified_at")
    op.alter_column("users", "email", existing_type=sa.String(length=320), nullable=False)
