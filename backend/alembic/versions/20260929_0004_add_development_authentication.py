"""Add development password credentials and opaque sessions.

Revision ID: 20260929_0004
Revises: 20260929_0003
Create Date: 2026-09-29
"""

import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

from alembic import op

revision = "20260929_0004"
down_revision = "20260929_0003"
branch_labels = None
depends_on = None


def upgrade() -> None:
    uuid = postgresql.UUID(as_uuid=False)
    op.create_table(
        "user_password_credentials",
        sa.Column("user_id", uuid, nullable=False),
        sa.Column("password_hash", sa.Text(), nullable=False),
        sa.Column("password_changed_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("id", uuid, nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.ForeignKeyConstraint(["user_id"], ["users.id"]),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint("user_id"),
    )
    op.create_index(
        "ix_user_password_credentials_user_id", "user_password_credentials", ["user_id"]
    )
    op.create_table(
        "development_sessions",
        sa.Column("user_id", uuid, nullable=False),
        sa.Column("token_hash", sa.String(length=128), nullable=False),
        sa.Column("expires_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("revoked_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("id", uuid, nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.ForeignKeyConstraint(["user_id"], ["users.id"]),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint("token_hash"),
    )
    op.create_index("ix_development_sessions_user_id", "development_sessions", ["user_id"])
    op.create_index("ix_development_sessions_token_hash", "development_sessions", ["token_hash"])


def downgrade() -> None:
    op.drop_index("ix_development_sessions_token_hash", table_name="development_sessions")
    op.drop_index("ix_development_sessions_user_id", table_name="development_sessions")
    op.drop_table("development_sessions")
    op.drop_index("ix_user_password_credentials_user_id", table_name="user_password_credentials")
    op.drop_table("user_password_credentials")
