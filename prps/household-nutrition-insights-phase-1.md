# Household Nutrition Insights Phase 1

## Related Spec

- `specs/household-nutrition-insights/overview.md`
- `specs/product-health-intelligence/overview.md`

## Related ADRs

- `docs/adr/0012-analyze-household-purchases-not-consumption.md`
- `docs/adr/0011-model-packaged-product-variants-and-provenance.md`
- `docs/adr/0007-use-service-layer-shared-by-rest-and-mcp.md`
- `docs/adr/0008-use-provider-abstractions-for-external-services.md`

## Objective

Create the safe, deterministic foundation for Household Nutrition Insights
without representing purchases as consumption or fabricating dietary targets.

## Context

Products can hold source-backed declared nutrition data and purchases can link
to canonical products in the schema, but household/member, purchase, and
shopping-list application services are not implemented. No approved Indian
nutrition-reference methodology exists in the repository.

## Scope

- Member CRUD service/API and lightweight mobile management.
- Deterministic aggregation contracts, data-completeness handling, and
  provenance-preserving result models.
- Explicit not-approved reference-methodology implementation.
- Nutrition-insight REST/mobile workflow with safe empty and unavailable states.
- Recommendation and shopping-list integration service contracts without
  invented recommendation data.

## Out of Scope

- Receipt/purchase ingestion, clinical guidance, targets, adequacy scores,
  nutrient-gap recommendations, LLM calculations, and price optimization.

## Existing Code to Review

- `backend/app/domains/households/models.py`
- `backend/app/domains/products/models.py`
- `backend/app/domains/purchases/models.py`
- `backend/app/services/product_intelligence_service.py`
- `mobile/lib/features/insights/`
- `mobile/lib/features/profile/`
- `mobile/lib/features/shopping_lists/`

## Implementation Requirements

- Use the canonical Product model and provenance-backed nutrition snapshots.
- Exclude unknown values rather than converting them to zero.
- Keep calculations in backend services and keep REST/MCP thin.
- Do not collect member weight or medical data in this phase.
- Do not present status values that imply dietary adequacy.

## Data Model Impact

- Add optional household-member date of birth, sex, and active state.
- Add an optional ProductVariant reference to purchase items for future precise
  package-level nutrient analysis.

## API Impact

- Household-member endpoints.
- Household nutrition insight endpoint.
- No unauthenticated purchase or recommendation mutation endpoint is added
  until the purchase/shopping-list service specs are active.

## Security Considerations

- Household data is sensitive. Development password authentication exists, but
  an authenticated-principal dependency has not yet been applied to
  household-scoped APIs; production authorization remains a prerequisite for
  exposing live data.
- Do not retain medical details, receipt images, or raw provider payloads in
  nutrition responses.

## Testing Requirements

- Household member validation and deactivate behavior.
- Deterministic date-range aggregation, unknown values, provenance, and
  unsupported quantities.
- API response mapping.
- Mobile empty/unavailable-state navigation tests.

## Acceptance Criteria

- Meet the active Phase 1 criteria in the related spec.

## Validation Commands

```bash
cd backend
ruff format --check .
ruff check .
pytest

cd ../mobile
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test

cd ..
docker compose config
```

## Risks

- Purchase ingestion is not yet implemented, so a real installation will show
  no-history states until the dedicated purchase workflow is delivered.
- An approved methodology and enriched nutrient dataset are required before
  food recommendations or adequacy claims can be released.
