# Authentication Spec

STATUS: ACTIVE - DEVELOPMENT EMAIL/PASSWORD AUTHENTICATION IMPLEMENTED

## Implemented Foundation

- `User` supports optional primary email/mobile contacts, independent verified
  timestamps, account status, and a platform role.
- `UserIdentity` stores a provider and provider subject for future OIDC, Apple,
  Google, email, and mobile-OTP identities without storing credentials.
- Existing users retain their legacy email and are backfilled with an
  unverified `email` identity.
- Household invitations store only a hashed token; no plaintext invitation or
  recovery token is persisted.
- Development users can authenticate through a development-only email/password
  endpoint backed by Argon2id password hashes and opaque, hashed sessions.
- The mobile sign-in flow calls the endpoint and stores only the returned
  opaque access token in platform secure storage.

## Blocked / Planned

- OIDC/JWT validation and authenticated principal dependency for production
  APIs
- Apple, Google, email, and mobile OTP sign-in flows
- Verified-contact delivery and account recovery workflow
- Token lifecycle, revocation, and session management

Development password authentication is explicitly limited to local development
and test environments. Seed passwords are required from ignored environment
variables, are never printed by the seed command, and are not valid production
configuration. No current household endpoint may treat a caller-supplied user
or household ID as proof of authorization. Production transport enforcement
begins only after the authenticated-principal dependency is implemented.
