from __future__ import annotations

from logging.config import fileConfig

from sqlalchemy import engine_from_config, pool

from alembic import context
from app.core.config.settings import get_settings
from app.db.base import Base
from app.domains.audit import models as audit_models  # noqa: F401
from app.domains.households import models as household_models  # noqa: F401
from app.domains.pricing import models as pricing_models  # noqa: F401
from app.domains.products import models as product_models  # noqa: F401
from app.domains.purchases import models as purchase_models  # noqa: F401
from app.domains.receipts import models as receipt_models  # noqa: F401
from app.domains.shopping_lists import models as shopping_list_models  # noqa: F401
from app.domains.stores import models as store_models  # noqa: F401
from app.domains.users import models as user_models  # noqa: F401

config = context.config

if config.config_file_name is not None:
    fileConfig(config.config_file_name)

settings = get_settings()
config.set_main_option("sqlalchemy.url", settings.database_url)

target_metadata = Base.metadata


def run_migrations_offline() -> None:
    context.configure(
        url=settings.database_url,
        target_metadata=target_metadata,
        literal_binds=True,
        compare_type=True,
    )

    with context.begin_transaction():
        context.run_migrations()


def run_migrations_online() -> None:
    connectable = engine_from_config(
        config.get_section(config.config_ini_section, {}),
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )

    with connectable.connect() as connection:
        context.configure(connection=connection, target_metadata=target_metadata, compare_type=True)

        with context.begin_transaction():
            context.run_migrations()


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
