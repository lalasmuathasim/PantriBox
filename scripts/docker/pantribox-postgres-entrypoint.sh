#!/bin/sh

# Derive Postgres initialization values from the backend's single local
# connection contract. This script runs only in the isolated PantriBox image.
set -eu

database_url="${PANTRIBOX_DATABASE_URL:-}"
if [ -z "$database_url" ]; then
  echo "PANTRIBOX_DATABASE_URL must be configured in backend/.env." >&2
  exit 1
fi

connection="${database_url#*://}"
credentials="${connection%%@*}"
server_and_database="${connection#*@}"
database_name="${server_and_database#*/}"
database_name="${database_name%%\?*}"

if [ "$credentials" = "$connection" ] || [ "$database_name" = "$server_and_database" ]; then
  echo "PANTRIBOX_DATABASE_URL must include role, password, host, and database." >&2
  exit 1
fi

postgres_role="${credentials%%:*}"
postgres_password="${credentials#*:}"
if [ -z "$postgres_role" ] || [ -z "$postgres_password" ] || [ -z "$database_name" ]; then
  echo "PANTRIBOX_DATABASE_URL must include non-empty role, password, and database values." >&2
  exit 1
fi

export POSTGRES_USER="$postgres_role"
export POSTGRES_PASSWORD="$postgres_password"
export POSTGRES_DB="$database_name"

exec /usr/local/bin/docker-entrypoint.sh "$@"
