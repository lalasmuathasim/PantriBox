# Database Operations

PantriBox treats PostgreSQL as the authoritative store for transactional facts.
Schema structure is recreated from the version-controlled Alembic migration
chain; a Docker volume is never a schema source of truth.

## Default Local PostgreSQL

PantriBox's normal local database is its own PostgreSQL 16 container,
`pantribox-standalone-db`, backed by the persistent
`pantribox_standalone_postgres_data` volume. It listens only on
`127.0.0.1:5433`; it does not attach to, inspect, or repair another project's
PostgreSQL server, container, or volume.

The isolated container reads the ignored `backend/.env` connection URL and
derives its initial PostgreSQL role, password, and database from that single
value. This keeps Compose and the backend aligned without committing or
duplicating a password.

```bash
docker compose --profile standalone-db up -d
cd backend
source .venv/bin/activate
alembic upgrade head
python -m app.scripts.seed_development_users
```

## External Shared PostgreSQL

An existing shared PostgreSQL server is an explicit operator-managed
alternative, not the normal PantriBox provisioning path. PostgreSQL image
initialization variables do not create a role or database after its data
directory has been initialized.

Configure ignored `backend/.env` with:

```dotenv
PANTRIBOX_DATABASE_URL=postgresql+psycopg://pantribox_app:<local-secret>@localhost:5432/pantribox
PANTRIBOX_DATABASE_ADMIN_URL=postgresql://<local-postgres-admin>:<admin-secret>@localhost:5432/postgres
```

The administrator URL is read only by the explicit local provisioning command.
The running backend and Flutter app never use it. Neither value belongs in Git,
Flutter source, logs, specs, or ADRs.

With a PostgreSQL administrator account for the same local server, provision
only the PantriBox resources:

```bash
cd backend
source .venv/bin/activate
python -m app.scripts.provision_local_database
alembic upgrade head
python -m app.scripts.seed_development_users
```

The provisioning command creates `pantribox_app` and `pantribox` only when
missing, refuses privileged app roles or databases owned by another role,
revokes public database/schema access within PantriBox only, and confirms the
application URL connects as the intended role. It does not enumerate, alter,
delete, or reset another project's database, role, container, or volume.

`PANTRIBOX_DATABASE_ADMIN_URL` can be removed from `backend/.env` after
provisioning. It is not needed for normal backend startup, migrations, or
development seeding.

## Local Capacity Prerequisite

The standalone database initializes a PostgreSQL data directory on first run.
Docker must have sufficient free disk capacity for that volume. If startup logs
report `No space left on device` while creating `pg_wal`, free host/Docker disk
space and restart only `pantribox-standalone-db`; do not delete a shared
PostgreSQL volume as a workaround.

## Lifecycle Separation

| Stage | Purpose | Command |
| --- | --- | --- |
| Provisioning | Start the isolated PostgreSQL 16 service. Its first initialization derives the role/database from `PANTRIBOX_DATABASE_URL`. | `docker compose --profile standalone-db up -d` |
| Migration | Recreate or upgrade schema only. Never creates development accounts. | `alembic upgrade head` |
| Required bootstrap | Reference rows required in every environment. There are currently no database-backed reference rows; platform/household permission maps are versioned application code. | No command currently required. |
| Development seed | Local test accounts/sample data only. Disabled outside development/test. | `python -m app.scripts.seed_development_users` |

The development seed is idempotent and stores password hashes only. Its
credential inputs remain in ignored `backend/.env`.

The guarded `python -m app.scripts.provision_local_database` command remains
available only when an operator deliberately uses an external shared server.
It requires an administrator URL and must not be used for the isolated
standalone service.

## Backup And Lift-and-Shift

To move PantriBox later, apply the repository's migrations to the target first
and restore only PantriBox application data from a database-scoped backup.
An operator with appropriate privileges can use a custom-format backup such as:

```bash
pg_dump --format=custom --no-owner --no-privileges --dbname="$PANTRIBOX_DATABASE_URL" \
  --file=pantribox.backup
pg_restore --no-owner --no-privileges --dbname="$TARGET_PANTRIBOX_DATABASE_URL" \
  pantribox.backup
```

Secrets and backup files are sensitive. Do not commit them. Database creation,
role management, and restore permissions remain controlled operator actions.
