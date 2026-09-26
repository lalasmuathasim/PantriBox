# Contributing to PantriBox

## Workflow

1. Start with a product or technical spec in `specs/`.
2. Add or review an ADR in `docs/adr/` when making an architectural decision.
3. Create a PRP in `prps/` before implementation.
4. Implement with tests and validation commands.
5. Update docs when behavior, interfaces, or architecture changes.

## Development standards

- Prefer small, reviewable changes.
- Keep business logic out of transport layers.
- Reuse existing abstractions before creating new ones.
- Protect household, purchase, and receipt data.
- Avoid speculative infrastructure and dependencies.

## Validation

- Backend: format, lint, tests, health endpoint.
- Mobile: format, analyze, widget tests.
- Documentation: ensure specs, ADRs, and README remain aligned with implementation.

