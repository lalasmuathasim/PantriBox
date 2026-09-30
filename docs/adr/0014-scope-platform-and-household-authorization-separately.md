# 0014 Scope Platform And Household Authorization Separately

- Title: Scope Platform And Household Authorization Separately
- Status: Accepted
- Date: 2026-09-29

## Context

Operational platform access and a household member's access to private
shopping data are different security concerns. A shared role field would make
accidental privilege inheritance likely.

## Decision

Use platform roles (`USER`, `ADMIN`, `SUPER_ADMIN`) and household roles
(`OWNER`, `ADMIN`, `MEMBER`, `VIEWER`) with separate centralized permission
maps. Platform administration never grants household access. Platform role
assignment is server-authorized and auditable.

## Alternatives Considered

- A single global role field
- Scattered `is_admin` conditionals
- Implicit household access for platform admins

## Consequences

- Authorization services require both actor and resource context.
- A future authentication transport must supply a verified principal.
- Admin operational work remains outside the consumer mobile experience.

## Related Specs / PRPs

- `specs/data-architecture/overview.md`
- `prps/data-architecture-hardening.md`
