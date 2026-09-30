# Product Foundation Acceptance Criteria

STATUS: ACTIVE

## Acceptance criteria

- Mobile app runs with PantriBox theme and navigation shell.
- Backend starts and exposes representative versioned endpoints.
- Local PostgreSQL is configured through the isolated `standalone-db` Docker
  Compose profile and requires sufficient local Docker disk capacity to start.
- Mobile architecture includes an API client path to the backend.
- Backend uses service/domain boundaries and avoids business logic in route handlers.
- MCP boundary exists and references the same service layer as REST.
- ADR, spec, and PRP frameworks are present and documented.
- Representative mobile and backend tests exist.
- CI validates formatting, analysis/linting, and tests.
