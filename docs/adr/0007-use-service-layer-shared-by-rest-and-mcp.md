# 0007 Use Service Layer Shared by REST and MCP

- Title: Use Service Layer Shared by REST and MCP
- Status: Accepted
- Date: 2026-08-22

## Context

PantriBox needs consistent behavior whether functionality is invoked from mobile APIs or future AI agent tools.

## Decision

Use a shared application/service layer consumed by both REST handlers and MCP tools.

## Alternatives Considered

- Duplicate logic in route handlers and agent tools
- Put business logic directly in the API layer
- Call REST endpoints from MCP instead of using internal services

## Consequences

- Domain logic stays in one place
- Testing can target service behavior directly
- Transport layers remain thin and replaceable

## Related Specs / PRPs

- `specs/product-foundation/overview.md`

