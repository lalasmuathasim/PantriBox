# 0002 Use FastAPI for Backend

- Title: Use FastAPI for Backend
- Status: Accepted
- Date: 2026-08-22

## Context

PantriBox needs a Python backend with OpenAPI generation, modern validation, async-capable APIs, and a good foundation for future AI and agent orchestration.

## Decision

Use FastAPI with Pydantic v2 for the HTTP API layer.

## Alternatives Considered

- Django REST Framework
- Flask
- Starlite / Litestar

## Consequences

- OpenAPI becomes the canonical contract
- Route handlers stay thin while services own business behavior
- The codebase remains well-positioned for future orchestration and MCP integration

## Related Specs / PRPs

- `specs/product-foundation/overview.md`

