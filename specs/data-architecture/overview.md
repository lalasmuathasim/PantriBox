# Data Architecture Evolution

STATUS: ACTIVE - FOUNDATION IMPLEMENTED; TRANSPORT AUTHENTICATION AND LIVE LOCAL DB VERIFICATION BLOCKED

## Objective

Evolve the existing PostgreSQL schema without destructive resets so that a
household is PantriBox's ownership and security boundary, while preserving
facts and provenance for shopping, receipt, purchase, price, nutrition, and
future agent workflows.

## Conceptual Model

```text
User --< UserIdentity
User --< HouseholdMembership >-- Household --< FamilyMember
Household --< HouseholdInvitation
Household --< ShoppingList --< ShoppingListItem
Household --< Receipt --0..1 Purchase --< PurchaseItem --0..* ProductPriceObservation
PurchaseItem --0..1 Product / ProductVariant
ProductVariant --< ProductInformationSnapshot --0..1 ProductNutritionDeclaration
ProductInformationSnapshot --< ProductIngredient
```

`HouseholdMember` is the existing physical table and application class for the
conceptual **FamilyMember**. It represents a person considered in household
analysis and may have no login. It must not contain credentials. A future
optional link to `User` is not household authorization; `HouseholdMembership`
is the authenticated access relationship.

## Relationships And Cardinalities

- One `User` has zero or many `UserIdentity` records; an identity belongs to
  exactly one user and `(provider, provider_subject)` is unique.
- One `Household` has one or many `HouseholdMembership` records; a user may
  belong to many households, but at most once per household.
- One household has zero or many FamilyMembers; a linked user may be
  represented by at most one FamilyMember in that household.
- One household has zero or many invitations, receipts, purchases, and
  shopping lists. Each of those records belongs to exactly one household.
- A receipt can produce zero or one purchase. A purchase has zero or many
  purchase items. A purchase item may retain a raw description without a
  canonical product match.
- A product has zero or many variants. Existing `ProductBarcode` is the
  current barcode-specific ProductIdentifier; broader identifier types remain
  deferred until a concrete source requires them.
- A product variant has zero or many source snapshots. Each snapshot has at
  most one declared ProductNutrition record and zero or many Ingredient rows.
- Price observations may link to a product, package variant, purchase item,
  store, and location where each fact is known. They are never deduplicated
  into a mutable "current price" record.

## Ownership And Isolation

- A `User` is an authenticated account identity, not a family member.
- A `Household` owns shopping lists, receipts, purchases, purchase items, and
  household-derived analytics.
- `HouseholdMembership` grants an authenticated user access to a household.
- Platform administrators do not implicitly receive a household membership.
- Services must resolve household authorization from the authenticated actor;
  an agent- or client-supplied household ID is a resource selector, never
  authorization evidence.

## Identity And RBAC

The schema supports verified primary email/mobile contact data on `User` and
provider subjects through `UserIdentity`. It stores neither passwords nor raw
recovery/invitation tokens. Future recovery is provider-managed or uses a
separate expiring, hashed-token workflow.

Platform roles: `USER`, `ADMIN`, `SUPER_ADMIN`.

Household roles: `OWNER`, `ADMIN`, `MEMBER`, `VIEWER`.

Role-to-permission mappings are centralized in backend authorization services.
They are not encoded as scattered boolean checks or merged into one role field.
Role assignment requires a platform permission and creates an audit event.

## Facts, Provenance, And Analytics

- Receipt OCR text, raw purchase descriptions, product matches, quantities,
  prices, sources, and confidence remain historical facts.
- `ProductPriceObservation` is append-only evidence; updates create a new
  observation rather than overwriting history.
- Unknown product and nutrition values are `NULL`/unknown, never zero.
- Shopping-list items are planned purchases and do not create purchase history.
- `purchase != consumption`: household purchase evidence does not establish
  individual intake, servings, food waste, or consumption.
- Derived spending, nutrition, and recommendation results are produced by
  deterministic query/domain services. Persisted future analysis runs must
  carry their period, methodology/rule version, data coverage, and evidence.

`AnalysisRun`, spending summaries, purchase trends, nutrition coverage, agent
runs, agent tool calls, and AI recommendations are **not** persisted in this
slice. The current nutrition response is reproducible from transactional
records and methodology metadata. A future persisted result is justified only
when it has a concrete user-facing cache, reproducibility, or audit need; it
must distinguish deterministic facts from AI-generated explanation and retain
evidence/provenance.

## Privacy And Data Isolation

- Raw receipt images remain in protected object storage references and are not
  public API assets.
- Email/mobile values, raw OCR, and audit details are sensitive and must be
  returned only through authenticated, authorized services.
- Audit details must exclude credentials, raw tokens, and unnecessary personal
  data.
- Membership checks are mandatory before household facts are exposed to REST,
  MCP, admin, or agent callers.

## Agent And Admin Boundaries

PostgreSQL is the authoritative structured datastore. REST, MCP, and future
agent tools call the same authorized domain/analytics services. Agents have no
direct database access and cannot choose a household outside their actor's
membership. LLMs may explain deterministic output but do not calculate facts
or alter authorization.

Future semantic/vector retrieval is an extension point only; no vector store
is introduced by this specification. A separate web admin portal is the
preferred future operational surface; the consumer mobile app remains free of
admin workflows.

## Migration Strategy

Migrations are additive or data-preserving. Existing users retain their
accounts, existing household owners are backfilled as owner memberships, and
existing email values become legacy email identities with unverified status.
No existing receipt, purchase, product, or price facts are removed.

## Database Provisioning And Reproducibility

PantriBox may use a PostgreSQL server shared with other local projects. It
owns one dedicated application role and one database; it must never repair a
missing role by deleting/recreating a shared container or volume. The required
ignored `PANTRIBOX_DATABASE_URL` is the canonical application/migration/seed
connection. Mobile receives an API base URL only and never database or backend
credentials.

Schema is created solely from the version-controlled Alembic migration chain.
Provisioning the database/role, migrating schema, required bootstrap, and
development seeding are separate operations. There are currently no
database-backed reference rows to bootstrap: platform and household permission
maps are versioned application code. Development accounts are idempotent,
development/test-only seed data and must never be created by migrations.

See `docs/architecture/database-operations.md` for the guarded local
provisioning path and future database-scoped backup/restore guidance.

## Acceptance Criteria

- Household membership is distinct from family-member records and prevents a
  duplicate active membership for the same user and household.
- Existing household owners receive owner memberships during migration.
- Platform and household role checks are centralized and independently scoped.
- A normal user cannot self-assign a platform role; privileged assignments are
  auditable.
- Purchase and price evidence carries explicit source/match provenance without
  overwriting historical observations.
- Migration SQL compiles for PostgreSQL and all backend tests pass.

## Implementation Tracker

| ID | Requirement | Status | Evidence |
| --- | --- | --- | --- |
| DATA-001 | Household ownership boundary | IMPLEMENTED | `household_memberships` migration, owner backfill, and authorization repository |
| DATA-002 | User versus FamilyMember separation | IMPLEMENTED | Existing `household_members` retained as FamilyMember; membership is separate |
| DATA-003 | User identity and verified contacts | PARTIAL | Verified contact fields and `user_identities` exist; OIDC/OTP flows are blocked |
| DATA-004 | Platform and household RBAC | PARTIAL | Separate roles and centralized authorization services exist; no JWT/OIDC transport principal yet |
| DATA-005 | Privileged audit trail | IMPLEMENTED | `audit_events` and auditable platform role-assignment service |
| DATA-006 | Purchase/receipt provenance | IMPLEMENTED | Receipt extraction and purchase-match metadata migration; ingestion workflow remains planned |
| DATA-007 | Historical price observations | IMPLEMENTED | Product-variant link plus historical query indexes |
| DATA-008 | Derived analytics separation | PARTIAL | Nutrition query service exists; no persisted analysis runs required yet |
| DATA-009 | Governed REST/MCP/agent service boundary | PARTIAL | Shared-service ADR/MCP registry and actor-scoped authorization foundation exist; no authenticated tool runtime |
| DATA-010 | Admin operational surface separation | DEFERRED | Backend foundation only; future web portal |
| DATA-011 | OIDC/JWT transport authentication | BLOCKED | Provider configuration and token validation are not implemented |
| DATA-012 | Vector/semantic retrieval | DEFERRED | PostgreSQL remains authoritative |
| DATA-013 | Product identifier model | PARTIAL | `ProductBarcode` covers barcode identifiers; generic identifiers deferred |
| DATA-014 | Source-backed nutrition and ingredients | IMPLEMENTED | Product snapshots, declared nutrition, and ingredients are canonical |
| DATA-015 | Persisted analysis / agent records | DEFERRED | No current cache or audit requirement justifies tables |
| DATA-016 | Isolated local PantriBox role/database provisioning | PARTIAL | `standalone-db` Compose profile derives initialization from the ignored backend URL; live startup is blocked by local Docker disk capacity |
| DATA-017 | Required explicit application database configuration | IMPLEMENTED | Required `PANTRIBOX_DATABASE_URL`; tracked credential-like defaults removed |
| DATA-018 | Version-controlled schema reproducibility | PARTIAL | Alembic chain compiles offline; empty live database verification is blocked by local Docker disk capacity |
| DATA-019 | Migration/bootstrap/development-seed separation | IMPLEMENTED | Migrations are schema-only; bootstrap state and development seed lifecycle documented |
| DATA-020 | Idempotent local development accounts | PARTIAL | Seed service tests pass; live database verification is blocked by local Docker disk capacity |
| DATA-021 | Database backup/lift-and-shift guidance | IMPLEMENTED | `docs/architecture/database-operations.md` |
