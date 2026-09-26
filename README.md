# PantriBox

PantriBox is a household shopping intelligence application focused on turning shopping lists, receipts, purchases, and price observations into reliable long-term grocery insights.

## Product vision

PantriBox starts with:

- Shopping lists
- Receipt capture and review
- Purchase logging
- Grocery spending visibility
- Product price history
- Cross-store price comparison
- Structured shopping optimization

The first Product Health Intelligence capability is also available:

- Cache-first packaged-food barcode lookup
- Provider-sourced product name, package information, nutrition, and ingredients
- Provenance and freshness metadata for product information

Future capabilities include AI shopping assistance, route optimization, price intelligence, nutrition-oriented insights, and household trend analysis.

## Repository structure

```text
pantribox/
├── mobile/
├── backend/
├── docs/
│   ├── architecture/
│   ├── product/
│   └── adr/
├── specs/
├── prps/
├── scripts/
├── .github/workflows/
├── AGENTS.md
├── README.md
├── CONTRIBUTING.md
├── docker-compose.yml
└── .env.example
```

## Architecture summary

- `mobile/`: Flutter application using Riverpod, GoRouter, Dio, Freezed-ready models, and a centralized PantriBox design system.
- `backend/`: FastAPI application with service/domain boundaries, PostgreSQL persistence, Alembic migrations, and MCP-ready capability boundaries.
- `docs/adr/`: Accepted architecture decisions.
- `specs/`: Product and technical feature specifications.
- `prps/`: Implementation-ready product requirement packets.

See [docs/product/vision.md](/Users/lalasmuathasim/Works/PantriBox/docs/product/vision.md) and [docs/architecture/system-overview.md](/Users/lalasmuathasim/Works/PantriBox/docs/architecture/system-overview.md).

## Local prerequisites

- Flutter SDK with iOS and Android toolchains
- Dart SDK
- Python 3.12+
- Docker Desktop
- PostgreSQL client tools optional

## Flutter setup

```bash
cd mobile
flutter pub get
flutter run
```

To temporarily switch back to the preserved legacy styling during development:

```bash
flutter run --dart-define=PANTRIBOX_THEME_VARIANT=legacy
```

## Backend setup

```bash
cd backend
python3 -m venv .venv
source .venv/bin/activate
pip install -e .[dev]
uvicorn app.main:app --reload
```

## Database setup

```bash
docker compose up -d db
```

Use `PANTRIBOX_DATABASE_URL` from `.env.example` or your local `.env`.

Apply the versioned schema after starting PostgreSQL:

```bash
cd backend
alembic upgrade head
```

## Tests

```bash
cd backend && pytest
cd mobile && flutter test
```

## Spec-driven workflow

1. Product or technical idea
2. Spec in `specs/`
3. ADR when architecture changes
4. PRP in `prps/`
5. Implementation
6. Tests and validation
7. Documentation updates

## ADR workflow

- Read existing ADRs before changing architecture.
- Add a new ADR instead of silently changing an accepted decision.
- Supersede earlier ADRs explicitly when needed.

## PRP workflow

- Create a PRP from the template in `prps/template.md`.
- Link the PRP to the relevant spec and ADRs.
- Include validation commands and testing expectations before implementation starts.

## Current bootstrap scope

This repository intentionally stops at a production-oriented foundation:

- Mobile app shell and navigation
- Backend shell and representative APIs
- PostgreSQL and Docker Compose foundation
- MCP-ready service boundaries
- Initial design system, docs, ADRs, specs, and CI

Barcode lookup is implemented as the first product-intelligence phase. Label OCR, camera barcode scanning, health scoring, claim analysis, and health-aware recommendations remain intentionally deferred.

Full product features are intentionally deferred to future specs and PRPs.
