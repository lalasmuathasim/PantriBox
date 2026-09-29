# Product Health Intelligence Overview

STATUS: ACTIVE - PHASE 1

## Objective

Let a household look up a packaged food barcode and view provider-sourced product name, package information, declared nutrition, and ingredients through the existing PantriBox Product domain.

## Included

- Barcode validation and normalization
- PantriBox cache-first lookup behavior
- Backend-only Open Food Facts read provider behind `ProductDataProvider`
- Canonical product, package variant, and provenance-aware persistence
- Structured REST lookup contract
- Mobile Scan hub, Home quick action, camera barcode capture, manual barcode entry, and product-information report
- Source freshness and incomplete-data states

## Excluded

- Product-label uploads, OCR, or vision extraction
- Product-image persistence or external image reuse
- Health scoring, medical advice, or marketing-claim assessment
- Health-aware shopping optimization
- External provider write operations

## Product Rules

- `Product` remains the canonical product concept; no parallel health-product entity is permitted.
- A barcode identifies a `ProductVariant`, not a generic product name.
- Missing nutrient values remain unknown and must not be presented as zero.
- Provider data is preserved with source and freshness metadata.
- A cache hit may be returned only while fresh. Stale data may be returned only with an explicit stale status when the provider is unavailable.
- Provider credentials and identifying headers remain backend-only.
- Barcode capture happens on-device and only submits the detected barcode to the
  existing PantriBox lookup endpoint. Product-label images are not captured or
  retained in this phase.
- The mobile scanner must request camera access through platform permissions and
  must ignore duplicate detections after a barcode has been accepted.

## Acceptance Criteria

- A valid barcode returns cached product information when a fresh result exists.
- A cache miss performs a provider lookup, persists a provenance-backed result, and returns structured product data.
- An unknown barcode returns a non-error not-found state and is negatively cached for a short period.
- Invalid barcodes receive a clear validation response.
- Product reports display only available product information and never fabricate nutrition values or health scores.
- Home includes a `Scan product` entry point using the existing quick-action
  pattern, and Scan Product offers camera capture with manual entry as a fallback.
- REST and future MCP capabilities share the same product-intelligence service boundary.
- Unit, service, API, and Flutter widget tests cover the phase-one flow.

## Household Nutrition Integration

The same source-backed declared nutrition representation is consumed by
Household Nutrition Insights. Current persisted fields support only the
declared nutrients available in this phase; iron, calcium, vitamins, and
reference-based nutrition assessments are not implemented.
