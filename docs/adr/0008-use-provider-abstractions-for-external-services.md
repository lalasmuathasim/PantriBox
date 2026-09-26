# 0008 Use Provider Abstractions for External Services

- Title: Use Provider Abstractions for External Services
- Status: Accepted
- Date: 2026-08-22

## Context

PantriBox expects to integrate with OCR, storage, routing, retailer, and AI providers over time. Coupling domain logic directly to a single vendor would reduce flexibility.

## Decision

Use provider abstractions for external services such as receipt storage, OCR extraction, product normalization, and routing.

## Alternatives Considered

- Direct vendor SDK calls from route handlers
- Vendor-specific logic embedded inside domain services
- One abstraction layer only when a second provider is already in use

## Consequences

- Initial bootstrap includes explicit interfaces instead of concrete integrations
- Replacing or adding providers later becomes safer
- Some up-front design effort is required even before vendor onboarding

## Related Specs / PRPs

- `specs/product-foundation/overview.md`

