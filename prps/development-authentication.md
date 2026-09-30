# Development Authentication

## Related Spec

- `specs/authentication/overview.md`
- `specs/data-architecture/overview.md`

## Related ADRs

- `docs/adr/0014-scope-platform-and-household-authorization-separately.md`
- `docs/adr/0018-use-argon2id-for-development-password-authentication.md`

## Objective

Replace placeholder mobile sign-in behavior with a development-only,
idempotently seeded email/password login path that respects existing platform
RBAC and does not store plaintext credentials.

## Context

The repository contains placeholder mobile fields and no authentication,
password, session, or seed implementation. The requested development accounts
need a safe local mechanism without being embedded in source, documentation,
or logs.

## Scope

- Argon2id password hash and opaque session persistence.
- Development-only login endpoint and idempotent seed command.
- Secure mobile token storage after successful sign-in.
- Remove all placeholder sign-in/sign-up navigation paths that bypass
  authentication.
- Tests for hash verification, idempotent seeds, successful/failed sign-in,
  and seeded platform roles.

## Out of Scope

- Production OIDC/JWT, password recovery delivery, sign-up, email/mobile
  verification, endpoint authorization rollout, account administration UI,
  and household-membership management.

## Existing Code to Review

- `backend/app/core/security/auth.py`
- `backend/app/domains/users/`
- `backend/app/services/authorization_service.py`
- `mobile/lib/features/authentication/`
- `mobile/lib/core/storage/secure_storage_service.dart`

## Implementation Requirements

- Use a vetted Argon2id library; do not implement a password KDF.
- Store password and session tokens only as hashes.
- Read development seed secrets from ignored environment variables.
- Seed operations must update existing records rather than duplicate them.
- Reject the development login endpoint outside development/test environments.

## Data Model Impact

Add password credentials and opaque session records related to `User`.

## API Impact

Add `POST /api/v1/auth/login` for development/test only.

## Security Considerations

Passwords are never logged or returned. The mobile app stores an opaque token
in `flutter_secure_storage`. Existing household APIs remain unauthenticated
until production JWT/OIDC work is approved.

## Testing Requirements

- Valid and invalid password behavior.
- Disabled account rejection.
- Seed idempotency and expected platform roles.
- Password hashes differ from source passwords.
- Mobile repository/sign-in state tests where feasible.

## Acceptance Criteria

- Requested accounts authenticate only with their configured development
  credentials.
- Their platform roles resolve as `super_admin` and `user`.
- No guest or placeholder route enters Home without successful authentication.

## Validation Commands

```bash
cd backend
ruff format --check .
ruff check .
pytest
alembic upgrade head --sql

cd ../mobile
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

## Risks

This local-only mechanism is not a replacement for production OIDC/JWT and
must be disabled outside development/test.
