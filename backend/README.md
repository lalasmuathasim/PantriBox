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

