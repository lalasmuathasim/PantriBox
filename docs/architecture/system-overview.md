# PantriBox System Overview

## Architecture layers

```text
Flutter Mobile UI
        ↓
Versioned REST API (FastAPI / OpenAPI)
        ↓
Application + Domain Services
       ↙ ↘
   MCP     Agent Orchestration
       ↘ ↙
 External Providers / Persistence
```

## Responsibilities

### Mobile UI

- Native-feeling iOS and Android experience
- Authentication flows
- Shopping list management
- Receipt capture and purchase review
- Insight presentation
- Backend API consumption only

### REST API

- Canonical application contract
- Versioned endpoints under `/api/v1`
- Request validation, auth boundaries, response models
- No embedded business logic in route handlers
- Future authenticated-principal dependency supplies actor context; a path
  household ID is never authorization evidence

### Domain services

- Shopping list operations
- Purchase and receipt workflows
- Product normalization boundaries
- Product intelligence lookup, provenance, and freshness boundaries
- Household-member management and deterministic nutrition-purchase aggregation
- Nutrition reference-methodology and recommendation-candidate boundaries
- Price observation creation
- Shopping optimization orchestration boundaries
- Centralized platform and household authorization checks

### MCP

- Agent-facing capabilities only
- Shared service layer with REST
- No duplicate domain logic
- Focus on meaningful operations such as `compare_prices` and `get_price_history`
- No direct PostgreSQL access; future tools inherit the authenticated actor and
  household authorization of their caller

### AI orchestration

- Backend-hosted, not mobile-hosted
- LLM as orchestrator and conversational layer
- Deterministic services for price, route, and optimization results

### External providers

- Receipt storage
- OCR provider
- Product normalization provider
- Product-data provider for barcode enrichment
- Routing provider
- Future retailer, maps, and AI integrations

### Persistence

- PostgreSQL as source of truth
- Dedicated least-privilege PantriBox role/database when a local server is
  shared; Flutter never receives database credentials
- Version-controlled Alembic migrations recreate schema independently of
  Docker volumes; bootstrap and development seeds are separate lifecycle steps
- Household membership as the authorization boundary for household facts
- Price observations with freshness and source metadata
- Receipt and purchase records retained for later normalization and intelligence
- Audit events for privileged actions; derived analytics are service/query
  outputs, not mutable fields on User or Household

## Boundary notes

- `purchase != consumption`
- Receipt text is preserved alongside normalized product references
- Price observations support multiple sources and confidence values
- External providers are hidden behind explicit interfaces
- Product nutrition and ingredient data is source-backed; it is not a health score or medical assessment
- Household nutrition insights analyze purchases, not individual consumption;
  approved reference methodology is required before quantitative adequacy
- A future separate web admin portal, rather than the consumer mobile app,
  will host operational administration
