# Local Database Provisioning And Reproducibility

## Related Spec

- `specs/data-architecture/overview.md`

## Related ADRs

- `docs/adr/0003-use-postgresql-as-primary-database.md`
- `docs/adr/0019-isolate-database-provisioning-from-migrations-and-seeds.md`

## Objective

Make PantriBox local PostgreSQL provisioning safe on a shared server while
keeping migrations, required bootstrap, and development seeds reproducible and
separate.

## Context

An initialized shared PostgreSQL Docker volume does not contain the role named
by the prior PantriBox configuration. Postgres image initialization variables
cannot repair an initialized cluster.

## Scope

- Require one ignored application database URL.
- Provide guarded, idempotent local role/database provisioning.
- Remove tracked credential-like defaults from runtime configuration.
- Keep Alembic schema-only and development seeding opt-in.
- Document backup/restore and a distinct standalone Docker fallback.

## Out of Scope

- Deleting/recreating shared volumes
- Modifying other project databases or roles
- Production infrastructure provisioning, RDS, backups, or credential rotation
- New consumer/mobile functionality

## Existing Code to Review

- `backend/app/core/config/settings.py`
- `backend/alembic/env.py`
- `backend/app/scripts/seed_development_users.py`
- `docker-compose.yml`

## Implementation Requirements

- The provisioning command must only operate on the role/database parsed from
  `PANTRIBOX_DATABASE_URL` and require an administrator connection to the same
  server's `postgres` maintenance database.
- It must reject privileged application roles and databases owned by another
  role.
- Migrations never seed development users.
- The app, migrations, and seed command use the same application URL.

## Data Model Impact

No schema changes. Existing Alembic revisions remain intact.

## API Impact

None. Mobile keeps using backend REST only.

## Security Considerations

Credentials remain in ignored local configuration. The app role is
least-privilege and scoped to its database. The admin URL is not consumed by
the running API.

## Testing Requirements

- Validate provisioning target/administrator safety checks.
- Compile migration SQL from the version-controlled chain.
- When administrator access is available, verify a fresh isolated PantriBox
  database can migrate and seed idempotently.

## Acceptance Criteria

- Meets `DATA-016` through `DATA-021` in the data-architecture tracker.

## Validation Commands

```bash
cd backend
ruff format --check .
ruff check .
pytest
alembic upgrade head --sql
python -m app.scripts.provision_local_database
alembic upgrade head
python -m app.scripts.seed_development_users
```

## Risks

Initial provisioning requires a local PostgreSQL administrator. The command
must not be run against an unknown or production database.
