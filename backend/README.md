# PantriBox Backend

FastAPI backend foundation for PantriBox.

## Run locally

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -e .[dev]
uvicorn app.main:app --reload
```

## Run tests

```bash
pytest
```

## Apply migrations

```bash
alembic upgrade head
```

## Local database lifecycle

`PANTRIBOX_DATABASE_URL` is required from ignored `backend/.env`; the backend
does not fall back to a shared/default PostgreSQL account. Normal local
development uses the isolated PostgreSQL 16 service on `127.0.0.1:5433`:

```bash
# From the repository root
docker compose --profile standalone-db up -d

# Then from backend/
alembic upgrade head
python -m app.scripts.seed_development_users
```

Migrations create schema only. Development accounts are optional idempotent
seed data. See `../docs/architecture/database-operations.md` for safeguards
and the explicit external-shared-server alternative.

## Product barcode lookup

`POST /api/v1/product-intelligence/barcode-lookups` provides cache-first packaged-food lookup through a backend-configured product-data provider. Configure its base URL, identifiable User-Agent, timeout, and cache TTLs with `PANTRIBOX_PRODUCT_*` variables from `.env.example`.
