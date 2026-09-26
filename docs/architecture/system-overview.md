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

### Domain services

- Shopping list operations
- Purchase and receipt workflows
- Product normalization boundaries
- Price observation creation
- Shopping optimization orchestration boundaries

### MCP

- Agent-facing capabilities only
- Shared service layer with REST
- No duplicate domain logic
- Focus on meaningful operations such as `compare_prices` and `get_price_history`

### AI orchestration

- Backend-hosted, not mobile-hosted
- LLM as orchestrator and conversational layer
- Deterministic services for price, route, and optimization results

### External providers

- Receipt storage
- OCR provider
- Product normalization provider
- Routing provider
- Future retailer, maps, and AI integrations

### Persistence

- PostgreSQL as source of truth
- Price observations with freshness and source metadata
- Receipt and purchase records retained for later normalization and intelligence

## Boundary notes

- `purchase != consumption`
- Receipt text is preserved alongside normalized product references
- Price observations support multiple sources and confidence values
- External providers are hidden behind explicit interfaces

