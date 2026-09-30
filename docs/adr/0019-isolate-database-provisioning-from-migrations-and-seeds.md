# 0019 Isolate Database Provisioning From Migrations And Seeds

- Title: Isolate Database Provisioning From Migrations And Seeds
- Status: Accepted
- Date: 2026-09-29

## Context

PantriBox runs against a local PostgreSQL server that can contain other
projects. The prior Compose configuration relied on PostgreSQL image
initialization variables and a persistent named volume. Those variables do not
create a role or database after a volume has already been initialized, which
made the configured application connection unreliable and encouraged unsafe
volume-reset recovery.

## Decision

Use a dedicated, least-privilege PantriBox application role and database on a
shared PostgreSQL server. The required `PANTRIBOX_DATABASE_URL` is the single
application connection contract and lives only in ignored local configuration.
A separate optional administrator URL may be used by an explicit,
development-only provisioning command that modifies only the configured
PantriBox role/database. Normal local development instead starts an isolated
PostgreSQL 16 Compose service that derives its initial role/database from the
same ignored application URL.

Alembic migrations remain the source of truth for schema. Required reference
bootstrap data and local development seeds are separate lifecycle stages.
Development users are seeded idempotently and never by migrations. Flutter
receives REST API URLs only, never database credentials.

## Alternatives Considered

- Resetting or recreating a shared Docker volume
- Relying on `POSTGRES_USER`/`POSTGRES_DB` initialization after first startup
- Embedding application credentials in Compose, Alembic, or source defaults
- Creating development users in migration files

## Consequences

- A PostgreSQL administrator must explicitly provision the initial local
  PantriBox role/database when one does not already exist.
- A fresh PantriBox database can be upgraded solely from version-controlled
  migrations, then optionally populated with development data.
- Local Docker provisioning uses the `standalone-db` profile, a distinct
  persistent volume, and loopback-only port `5433`; it never attaches to a
  shared server's existing volume.
- Backup/restore moves application data while migrations preserve schema
  reproducibility.

## Related Specs / PRPs

- `specs/data-architecture/overview.md`
- `prps/local-database-provisioning.md`
- `docs/architecture/database-operations.md`
