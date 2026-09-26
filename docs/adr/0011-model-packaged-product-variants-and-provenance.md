# 0011 Model Packaged Product Variants and Provenance

- Title: Model Packaged Product Variants and Provenance
- Status: Accepted
- Date: 2026-09-26

## Context

PantriBox needs barcode lookup and product-information enrichment without creating a second canonical product concept. A barcode identifies a specific packaged trade item; package size, formulation, ingredients, and nutrition values can differ for products that share a brand and display name. Externally sourced product data and later label-extracted data also need traceable provenance and safe precedence rules.

## Decision

Keep `Product` as the canonical PantriBox product concept. Model barcode-addressable package and formulation data as a `ProductVariant` related to `Product`. Store barcode mappings separately so unknown barcodes can be negatively cached without creating incomplete products.

Record product information as source-backed snapshots. Nutrition declarations and ingredients belong to a snapshot and retain source, retrieval time, source update time, confidence, and verification state. New lower-confidence data does not overwrite an existing snapshot; later selection rules resolve field values explicitly.

## Alternatives Considered

- Add barcode, nutrition, and ingredient fields directly to `Product`
- Create a separate `HealthProduct` or `BarcodeProduct` domain
- Replace existing product facts in place whenever a provider returns new data

## Consequences

- Product identity remains shared by shopping lists, purchases, receipts, pricing, and product intelligence.
- Product variants provide a precise future anchor for package-specific prices and nutrition facts.
- Additional tables and migration work are required before the feature can persist data.
- Health scoring remains a separate, future deterministic capability and is not introduced by this decision.

## Related Specs / PRPs

- `specs/product-health-intelligence/overview.md`
- `prps/product-barcode-lookup-foundation.md`
- `docs/adr/0008-use-provider-abstractions-for-external-services.md`
