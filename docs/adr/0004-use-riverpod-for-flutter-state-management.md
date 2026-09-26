# 0004 Use Riverpod for Flutter State Management

- Title: Use Riverpod for Flutter State Management
- Status: Accepted
- Date: 2026-08-22

## Context

PantriBox needs testable, explicit state-management primitives that work well with a feature-oriented Flutter architecture.

## Decision

Use Riverpod as the primary state-management solution in Flutter.

## Alternatives Considered

- Provider
- Bloc / Cubit
- Redux

## Consequences

- Shared state is declared explicitly through providers
- Tests can override dependencies predictably
- Additional state frameworks should not be introduced without strong justification

## Related Specs / PRPs

- `specs/product-foundation/overview.md`

