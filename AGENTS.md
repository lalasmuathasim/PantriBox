# PantriBox Agent Guide

This repository is designed for spec-driven, ADR-backed, PRP-guided development.

## Required workflow

1. Read relevant specs before implementation.
2. Read relevant ADRs before architectural changes.
3. Read the PRP before modifying a feature.
4. Do not contradict accepted ADRs silently.
5. Do not invent requirements.
6. Do not implement planned features without an active spec/PRP.
7. Prefer modifying existing abstractions over creating duplicates.
8. Do not duplicate domain logic between REST and MCP.
9. Tests are part of implementation, not optional follow-up work.
10. Run validation before marking work complete.
11. Update documentation when behavior or architecture changes.
12. Keep generated code and dependencies minimal.
13. Do not introduce infrastructure without justification.
14. Protect secrets and personally identifiable data.
15. Do not expose raw receipt images publicly.
16. Avoid storing unnecessary sensitive household information.

## Implementation guardrails

- The mobile app talks to the backend over versioned REST APIs.
- MCP capabilities must call the same application services used by REST handlers.
- Receipt text is not a canonical product identity.
- Purchase data must be designed for future price intelligence, not only expense tracking.
- Planned features remain placeholders until activated by a spec and PRP.

