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

## Product barcode lookup

`POST /api/v1/product-intelligence/barcode-lookups` provides cache-first packaged-food lookup through a backend-configured product-data provider. Configure its base URL, identifiable User-Agent, timeout, and cache TTLs with `PANTRIBOX_PRODUCT_*` variables from `.env.example`.
