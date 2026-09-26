# 0005 Use REST / OpenAPI for Application Contract

- Title: Use REST / OpenAPI for Application Contract
- Status: Accepted
- Date: 2026-08-22

## Context

The mobile application requires a stable, versioned contract to communicate with backend services and future internal consumers.

## Decision

Use versioned REST APIs with OpenAPI documentation as the canonical application contract.

## Alternatives Considered

- GraphQL
- RPC-only interfaces
- Mobile-direct database access

## Consequences

- Endpoints are versioned under `/api/v1`
- The mobile app integrates through HTTP APIs
- OpenAPI can support future contract review and SDK generation

## Related Specs / PRPs

- `specs/product-foundation/overview.md`

