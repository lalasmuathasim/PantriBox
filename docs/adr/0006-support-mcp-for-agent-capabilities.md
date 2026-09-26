# 0006 Support MCP for Agent Capabilities

- Title: Support MCP for Agent Capabilities
- Status: Accepted
- Date: 2026-08-22

## Context

PantriBox will eventually expose high-value capabilities to AI agents. Those capabilities should be designed explicitly instead of layering ad hoc agent access onto internal APIs later.

## Decision

Prepare a dedicated MCP boundary for agent-facing capabilities.

## Alternatives Considered

- No agent-facing interface
- Expose CRUD endpoints directly as agent tools
- Put agent logic entirely inside the mobile app

## Consequences

- Meaningful tools can be exposed later without duplicating domain behavior
- MCP remains capability-oriented instead of CRUD-oriented
- Additional implementation work is required to keep the boundary intentional

## Related Specs / PRPs

- `specs/product-foundation/overview.md`

