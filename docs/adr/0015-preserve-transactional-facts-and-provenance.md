# 0015 Preserve Transactional Facts And Provenance

- Title: Preserve Transactional Facts And Provenance
- Status: Accepted
- Date: 2026-09-29

## Context

Receipts, purchases, product matches, price observations, and derived insights
must remain explainable as product intelligence matures. Mutable summary
columns lose the evidence required to reproduce or correct conclusions.

## Decision

Retain raw descriptions, source/matching provenance, confidence, timestamps,
and product/variant references on transactional records. Treat price
observations as append-only historical evidence. Produce changing analytics
from services; introduce versioned persisted analysis records only when a
concrete product/audit need exists.

## Alternatives Considered

- Store only current price and normalized product values
- Add changing scores and summaries to User or Household
- Treat unknown values as zero

## Consequences

- Storage grows with evidence history but supports correction and trust.
- `purchase != consumption` remains intact for nutrition analysis.
- Queries require purpose-built indexes and services.

## Related Specs / PRPs

- `specs/data-architecture/overview.md`
- `prps/data-architecture-hardening.md`
