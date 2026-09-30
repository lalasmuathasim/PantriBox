# 0013 Household Ownership And Family Member Separation

- Title: Household Ownership And Family Member Separation
- Status: Accepted
- Date: 2026-09-29

## Context

PantriBox records shared shopping behavior but needs to distinguish an
authenticated account from a person represented in household analysis. The
existing `household_members` table is suitable for the latter but cannot be
used to authorize users.

## Decision

Use `Household` as the ownership and security boundary. Add
`HouseholdMembership` for authenticated user access and retain the existing
`HouseholdMember` table as the conceptual FamilyMember record. A FamilyMember
may later link to a User, but that link does not authorize household access.

## Alternatives Considered

- Treat every FamilyMember as a login
- Keep household owner as the only authorized user
- Merge family and membership records

## Consequences

- Multiple users can have scoped access to one household.
- Nutrition analysis can include people with no account.
- Existing owner records are backfilled as owner memberships.

## Related Specs / PRPs

- `specs/data-architecture/overview.md`
- `prps/data-architecture-hardening.md`
