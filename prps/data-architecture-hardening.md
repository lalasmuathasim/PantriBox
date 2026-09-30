# Data Architecture Hardening

## Related Spec

- `specs/data-architecture/overview.md`
- `specs/household-nutrition-insights/overview.md`
- `specs/product-health-intelligence/overview.md`

## Related ADRs

- `docs/adr/0003-use-postgresql-as-primary-database.md`
- `docs/adr/0007-use-service-layer-shared-by-rest-and-mcp.md`
- `docs/adr/0011-model-packaged-product-variants-and-provenance.md`
- `docs/adr/0012-analyze-household-purchases-not-consumption.md`
- `docs/adr/0013-household-ownership-and-family-member-separation.md`
- `docs/adr/0014-scope-platform-and-household-authorization-separately.md`
- `docs/adr/0015-preserve-transactional-facts-and-provenance.md`
- `docs/adr/0016-govern-agent-access-through-shared-services.md`
- `docs/adr/0017-separate-admin-operations-from-consumer-mobile.md`

## Objective

Add the data and service foundations required for household isolation,
identity evolution, scoped authorization, privileged auditability, and
provenance-preserving transactional facts.

## Context

The initial schema contains the core transactional entities and nutrition
foundation but lacks a separate authenticated membership model and real RBAC.
Existing records must be preserved through additive Alembic migrations.

## Scope

- Add identity/contact, membership, invitation, and audit schema foundations.
- Backfill household owners as owner memberships and existing emails as legacy
  unverified identities.
- Add purchase/receipt matching provenance and product-variant price evidence.
- Add centralized, unit-testable platform and household authorization services.
- Update MCP capability documentation to name governed future capabilities.
- Update implementation statuses only after code, migration, and tests exist.

## Out of Scope

- OIDC/JWT implementation, credential storage, recovery delivery, invitation
  delivery, consumer admin UI, agent runtime, vector database, analysis-run
  persistence, receipt ingestion, and shopping-list/purchase CRUD.

## Existing Code to Review

- `backend/alembic/versions/20260926_0001_initial_pantribox_schema.py`
- `backend/app/domains/households/`
- `backend/app/domains/users/`
- `backend/app/domains/purchases/`
- `backend/app/domains/pricing/`
- `backend/app/services/household_nutrition_service.py`
- `backend/app/mcp/registry.py`

## Implementation Requirements

- Use string-backed enums and centralized permission maps.
- Preserve existing table names and family-member data.
- Do not add direct agent database access or endpoint authentication based on a
  caller-supplied header.
- Never store raw invitation/recovery tokens in PostgreSQL.
- Keep analytical values out of `User` and `Household` columns.

## Data Model Impact

Add `user_identities`, `household_memberships`, `household_invitations`, and
`audit_events`; extend users, receipts, purchases, purchase items, and price
observations; add integrity constraints and query indexes.

## API Impact

No consumer API behavior changes. Authorization services are transport-neutral
until a real OIDC/JWT dependency can produce an authenticated principal.

## Security Considerations

Platform roles and household roles are independent. Privilege changes require
permission checks and audit events. Current household-path APIs remain a
development-only transport limitation until OIDC/JWT authentication is active.

## Testing Requirements

- Platform-role assignment and self-escalation denial.
- Household role isolation and no implicit platform-admin household access.
- Membership duplicate constraint metadata.
- Provenance and price-history schema metadata.
- Alembic PostgreSQL SQL compilation.

## Acceptance Criteria

- Meets `specs/data-architecture/overview.md` acceptance criteria.

## Validation Commands

```bash
cd backend
ruff format --check .
ruff check .
pytest
alembic upgrade head --sql
```

## Risks

Real API enforcement cannot be safely introduced until a verified principal is
available from OIDC/JWT. The foundation must document this as blocked rather
than accepting caller-controlled identity headers.
