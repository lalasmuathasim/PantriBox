# 0003 Use PostgreSQL as Primary Database

- Title: Use PostgreSQL as Primary Database
- Status: Accepted
- Date: 2026-08-22

## Context

PantriBox requires relational integrity across users, households, products, purchases, receipts, and price observations while remaining extensible for analytical queries.

## Decision

Use PostgreSQL as the primary database.

## Alternatives Considered

- SQLite
- MySQL
- NoSQL document database

## Consequences

- Strong relational modeling for current and future domains
- Straightforward use with SQLAlchemy and Alembic
- Local development requires a database service

## Related Specs / PRPs

- `specs/product-foundation/overview.md`

