# 0016 Govern Agent Access Through Shared Services

- Title: Govern Agent Access Through Shared Services
- Status: Accepted
- Date: 2026-09-29

## Context

Future PantriBox agents need trustworthy spending, price, and nutrition
capabilities without unrestricted database access or duplicated REST/MCP logic.

## Decision

Agents, REST handlers, and MCP tools use the same authorized domain and
analytics services. Every tool receives an authenticated actor context and
checks household membership before selecting data. PostgreSQL remains the
authoritative store; vector/semantic retrieval is deferred until a concrete,
governed use case exists.

## Alternatives Considered

- Direct database access from agents
- Separate agent and REST business implementations
- Introduce a vector database now

## Consequences

- Agent capabilities are capability-oriented and auditable.
- LLMs cannot select households or alter deterministic calculations.
- Future semantic retrieval is additive and cannot replace structured facts.

## Related Specs / PRPs

- `specs/data-architecture/overview.md`
- `prps/data-architecture-hardening.md`
- `docs/adr/0006-support-mcp-for-agent-capabilities.md`
- `docs/adr/0007-use-service-layer-shared-by-rest-and-mcp.md`
