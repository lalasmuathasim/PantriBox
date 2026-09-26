# Product Barcode Lookup Foundation

## Related Spec

- `specs/product-health-intelligence/overview.md`

## Related ADRs

- `docs/adr/0005-use-rest-openapi-for-application-contract.md`
- `docs/adr/0007-use-service-layer-shared-by-rest-and-mcp.md`
- `docs/adr/0008-use-provider-abstractions-for-external-services.md`
- `docs/adr/0011-model-packaged-product-variants-and-provenance.md`

## Objective

Implement a cache-first barcode lookup foundation that enriches the canonical Product domain with provider-sourced package, nutrition, ingredient, freshness, and provenance data.

## Context

PantriBox has product model scaffolding, a versioned REST API, a centralized mobile design system, and an unused receipt image-picker abstraction. It has no barcode scanner, product provider, feature APIs, repositories, migrations, nutrition data model, or analytics system.

## Scope

- Add packaged product variants, barcode records, data snapshots, nutrition declarations, and ingredient records.
- Add an Open Food Facts read client behind a provider contract.
- Add cache-first lookup service and REST endpoint.
- Add Scan hub, manual product barcode lookup, and a structured product information report.
- Add representative backend and mobile tests.

## Out of Scope

- Label capture, OCR, vision, camera barcode scanning, health scoring, claims, product images, provider writes, and product recommendations.

## Existing Code to Review

- `backend/app/domains/products/models.py`
- `backend/app/services/interfaces.py`
- `backend/app/integrations/providers.py`
- `backend/app/api/v1/router.py`
- `mobile/lib/features/receipt_scan/presentation/receipt_scan_screen.dart`
- `mobile/lib/app/routing/app_router.dart`
- `mobile/lib/shared/widgets/`

## Implementation Requirements

- Keep provider logic out of route handlers and Product domain entities.
- Use only a backend-configured Open Food Facts base URL and User-Agent.
- Treat provider failures as recoverable; return stale cached data where available.
- Preserve declared values and calculate no health score.
- Do not expose raw provider payloads, provider credentials, or product images through the API.

## Data Model Impact

- Add `ProductVariant`, `ProductBarcode`, `ProductInformationSnapshot`, `ProductNutritionDeclaration`, and `ProductIngredient`.
- Add a migration covering the new relations and indexes.

## API Impact

- Add `POST /api/v1/product-intelligence/barcode-lookups`.
- Add structured response states: `found`, `not_found`, `stale`, and `incomplete`.

## Security Considerations

- No user label images are captured in this phase.
- Provider identification remains in backend configuration.
- Barcode values are not emitted to analytics or logs beyond operationally necessary request handling.

## Testing Requirements

- Barcode validation and cache-freshness unit tests.
- Provider mapping and failure tests using mocked HTTP transport.
- Service and API tests with fakes or dependency overrides.
- Flutter route and product lookup UI tests.

## Acceptance Criteria

- Satisfy every criterion in `specs/product-health-intelligence/overview.md`.

## Validation Commands

```bash
cd backend && ruff format --check . && ruff check . && pytest
cd mobile && dart format --output=none --set-exit-if-changed . && flutter analyze && flutter test
docker compose config
```

## Risks

- Open Food Facts coverage and completeness for Indian packaged products remain unvalidated.
- Open Food Facts data and image licensing obligations require ongoing legal and attribution review.
- The database must be migrated before running the endpoint against PostgreSQL.
