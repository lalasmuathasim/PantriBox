"""Provision only the PantriBox application role and database on a shared local server."""

from __future__ import annotations

from dataclasses import dataclass

import psycopg
from psycopg import sql
from sqlalchemy.engine import URL, make_url

from app.core.config.settings import get_settings


@dataclass(frozen=True)
class DatabaseTarget:
    database_name: str
    password: str
    role_name: str
    url: URL


def as_psycopg_url(url: URL | str) -> str:
    parsed_url = url if isinstance(url, URL) else make_url(url)
    return parsed_url.set(drivername="postgresql").render_as_string(hide_password=False)


def get_database_target(database_url: str) -> DatabaseTarget:
    url = make_url(database_url)
    if not url.database or not url.username or url.password is None:
        raise RuntimeError("PANTRIBOX_DATABASE_URL must contain a database, role, and password.")
    if url.username in {"postgres", "root"}:
        raise RuntimeError("PANTRIBOX_DATABASE_URL must use a dedicated application role.")
    return DatabaseTarget(
        database_name=url.database,
        password=str(url.password),
        role_name=url.username,
        url=url,
    )


def verify_admin_target(admin_url: URL, target: DatabaseTarget) -> None:
    if admin_url.host != target.url.host or admin_url.port != target.url.port:
        raise RuntimeError("PANTRIBOX_DATABASE_ADMIN_URL must point to the same PostgreSQL server.")
    if admin_url.database != "postgres":
        raise RuntimeError(
            "PANTRIBOX_DATABASE_ADMIN_URL must connect to the postgres maintenance database."
        )


def create_role_if_missing(connection: psycopg.Connection, target: DatabaseTarget) -> None:
    with connection.cursor() as cursor:
        cursor.execute(
            "SELECT rolsuper, rolcreatedb, rolcreaterole FROM pg_roles WHERE rolname = %s",
            (target.role_name,),
        )
        role = cursor.fetchone()
        if role is None:
            cursor.execute(
                sql.SQL(
                    "CREATE ROLE {} LOGIN PASSWORD {} NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT"
                ).format(sql.Identifier(target.role_name), sql.Literal(target.password))
            )
            return
        if any(role):
            raise RuntimeError(
                "The configured PantriBox role has privileged PostgreSQL attributes."
            )


def create_database_if_missing(connection: psycopg.Connection, target: DatabaseTarget) -> None:
    with connection.cursor() as cursor:
        cursor.execute(
            """
            SELECT database_role.rolname
            FROM pg_database database
            JOIN pg_roles database_role ON database_role.oid = database.datdba
            WHERE database.datname = %s
            """,
            (target.database_name,),
        )
        row = cursor.fetchone()
        if row is None:
            cursor.execute(
                sql.SQL("CREATE DATABASE {} OWNER {} ENCODING 'UTF8'").format(
                    sql.Identifier(target.database_name), sql.Identifier(target.role_name)
                )
            )
        elif row[0] != target.role_name:
            raise RuntimeError("The configured PantriBox database is owned by a different role.")

        cursor.execute(
            sql.SQL("REVOKE ALL ON DATABASE {} FROM PUBLIC").format(
                sql.Identifier(target.database_name)
            )
        )
        cursor.execute(
            sql.SQL("GRANT CONNECT, TEMPORARY ON DATABASE {} TO {}").format(
                sql.Identifier(target.database_name), sql.Identifier(target.role_name)
            )
        )


def secure_public_schema(admin_url: str, target: DatabaseTarget) -> None:
    target_admin_url = as_psycopg_url(make_url(admin_url).set(database=target.database_name))
    with psycopg.connect(target_admin_url, autocommit=True) as connection:
        with connection.cursor() as cursor:
            cursor.execute(
                sql.SQL("ALTER SCHEMA public OWNER TO {}").format(sql.Identifier(target.role_name))
            )
            cursor.execute("REVOKE ALL ON SCHEMA public FROM PUBLIC")
            cursor.execute(
                sql.SQL("GRANT USAGE, CREATE ON SCHEMA public TO {}").format(
                    sql.Identifier(target.role_name)
                )
            )


def verify_application_connection(database_url: str, target: DatabaseTarget) -> None:
    with psycopg.connect(as_psycopg_url(database_url)) as connection:
        with connection.cursor() as cursor:
            cursor.execute("SELECT current_user, current_database()")
            user, database = cursor.fetchone()
    if user != target.role_name or database != target.database_name:
        raise RuntimeError(
            "The configured application connection did not reach the PantriBox role/database."
        )


def main() -> None:
    settings = get_settings()
    if settings.env not in {"development", "test"}:
        raise RuntimeError("Local database provisioning is disabled outside development/test.")
    admin_url = (
        settings.database_admin_url.get_secret_value()
        if settings.database_admin_url is not None
        else ""
    )
    if not admin_url.strip():
        raise RuntimeError(
            "PANTRIBOX_DATABASE_ADMIN_URL is required and must remain in ignored backend/.env."
        )

    target = get_database_target(settings.database_url)
    verify_admin_target(make_url(admin_url), target)
    with psycopg.connect(admin_url, autocommit=True) as connection:
        create_role_if_missing(connection, target)
        create_database_if_missing(connection, target)
    secure_public_schema(admin_url, target)
    verify_application_connection(settings.database_url, target)
    print("PantriBox database role and database are ready.")


if __name__ == "__main__":
    main()
