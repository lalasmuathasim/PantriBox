# 0017 Separate Admin Operations From Consumer Mobile

- Title: Separate Admin Operations From Consumer Mobile
- Status: Accepted
- Date: 2026-09-29

## Context

PantriBox needs auditable operational controls without exposing privileged
administration in the household shopping application.

## Decision

Provide backend RBAC and audit foundations now. Build any future operational
interface as a separate web admin portal, not a mobile consumer dashboard.

## Alternatives Considered

- Mobile admin dashboard
- No durable audit record for privileged actions
- Unrestricted database access for operations

## Consequences

- Consumer mobile navigation stays focused on households and shopping.
- Privileged workflows require explicit authorization and an audit event.
- Admin UI delivery is intentionally deferred.

## Related Specs / PRPs

- `specs/data-architecture/overview.md`
- `prps/data-architecture-hardening.md`
