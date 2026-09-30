# 0018 Use Argon2id For Development Password Authentication

- Title: Use Argon2id For Development Password Authentication
- Status: Accepted
- Date: 2026-09-29

## Context

PantriBox needs local development accounts before production OIDC/JWT is
implemented. The existing repository has no password storage mechanism, and
plaintext seed credentials must not enter source control, logs, or product
documentation.

## Decision

Use the vetted `pwdlib` Argon2id implementation for development password
hashing. Store a single password hash per user in a dedicated credential
record, generate opaque random session tokens, and persist only session token
hashes. Source user data and passwords come from ignored local environment
configuration through an idempotent development seed command.

## Alternatives Considered

- Plaintext seed passwords in source files
- A custom password hash implementation
- Treat placeholder mobile navigation as authentication
- Delay all local login until production OIDC is ready

## Consequences

- Local development can verify authentication and RBAC safely.
- This path is disabled outside development/test environments.
- Production OIDC/JWT and verified identity providers remain separate work.

## Related Specs / PRPs

- `specs/authentication/overview.md`
- `prps/development-authentication.md`
