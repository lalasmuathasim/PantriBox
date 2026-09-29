# Household Nutrition Insights

STATUS: ACTIVE - PHASE 1 IMPLEMENTED WITH DATA/METHODOLOGY LIMITATIONS

## Objective

Provide a deterministic, non-medical view of nutrition information represented
in a household's identified grocery purchases over a selected date range.

PantriBox describes this as **household grocery nutrition coverage**, never as
individual nutrient intake or medical advice.

## Invariant

`purchase != consumption`

Purchases and receipts indicate what entered a household grocery basket. They
do not establish who consumed an item, serving sizes, waste, pantry carryover,
or food eaten outside the home. The service must not divide purchased food by
the number of household members or claim individual adequacy/deficiency.

## Domain Boundaries

- `households`: member identity and minimal active-status profile data.
- `products`: the canonical Product and ProductVariant retain nutrition source,
  freshness, confidence, and declared values. No nutrition-specific product
  model is permitted.
- `purchases`: purchase items retain their raw receipt description and optional
  canonical product/variant references. Only supported identified items with a
  usable quantity can contribute to calculated totals.
- `nutrition`: deterministic aggregation, reference-methodology selection,
  insight assembly, and recommendation-candidate generation.
- `shopping_lists`: selected recommendations are added through the existing
  shopping-list service, not a second list type.

## Phase 1 Scope

- Household member CRUD with display name, optional date of birth, optional
  sex, and active/inactive state. Weight and medical attributes are excluded.
- Date-range aggregation of supported declared product nutrients from household
  purchases.
- Data-completeness reporting: total purchase items, identified items, items
  with nutrition declarations, and items usable for quantity-based totals.
- Nutrition provenance returned alongside calculated values.
- A versioned nutrition-reference abstraction that reports an explicit
  `not_approved` state until a methodology is approved.
- REST and mobile insight views that communicate unavailable/insufficient data
  without fabricated health statuses.
- A recommendation and shopping-list integration boundary. Gap-derived food
  recommendations remain unavailable until a reference methodology and food
  relationship data are approved.

## Explicitly Not Implemented in Phase 1

- Receipt upload/OCR, receipt review, manual purchase entry, and purchase
  history APIs. The database models exist but the purchase workflow is still
  specified separately.
- Indian RDA/NIN/ICMR or food-composition reference values. These must be
  researched, licensed where required, approved, and versioned before use.
- Quantitative adequacy scores, target percentages, deficiency claims,
  nutrient-gap labels, or food recommendations based on gaps.
- Iron, calcium, or vitamin totals. The current Product Health implementation
  does not persist those declared nutrients.
- AI-generated calculations, clinical advice, individual nutrition profiles,
  pantry/consumption estimates, and price-aware nutrition optimization.

## Methodology And Provenance

Every result exposes:

- `reference_methodology_id` and `reference_methodology_version`
- methodology approval/readiness state
- product nutrition source, retrieved time, confidence, and verification state
  for contributing records
- data-completeness counts and an explanation of excluded records

The initial methodology has no approved nutrient targets. The UI must make
this visible and must not render Good/Low/Could improve statuses from raw
purchase totals.

## Future Flow

```text
Receipt / manual purchase
        ↓
Canonical product and variant resolution
        ↓
Source-backed nutrition facts
        ↓
Deterministic household purchase aggregation
        ↓
Approved reference methodology
        ↓
Coverage insights and deterministic recommendation candidates
        ↓
Selected items added to an existing shopping list
```

Price observations remain independent inputs. Future optimization can combine
approved nutrition recommendations with price and availability, but Phase 1
does not require price intelligence.

## Acceptance Criteria

- Member changes preserve active/inactive state and collect no unnecessary
  medical data.
- Aggregation is deterministic for the same records, date range, and
  methodology version.
- Missing nutrition values are not treated as zero.
- Quantity-based totals use only supported mass units and explicit quantities.
- Results report completeness and provenance before any calculated values.
- Results use household-purchase language and contain no individual or medical
  claims.
- REST and future MCP share the same service boundary.
- The mobile screen provides useful no-history, incomplete-data, and
  methodology-unavailable states.

## Implementation Status

- [x] Household member API and mobile management route. The live mobile route
  activates when authentication supplies a household identifier.
- [x] Deterministic aggregation service and API
- [x] Reference methodology abstraction with an explicit `not_approved` state
- [x] Mobile insights workflow with setup, no-history, unavailable-data, and
  methodology-pending states
- [x] Recommendation-to-shopping-list service boundary. It returns no
  candidates until an approved methodology and food relationship dataset exist.
- [ ] Approved Indian reference methodology and nutrient dataset
- [ ] Purchase ingestion workflow
- [ ] Quantitative coverage and actionable food recommendations

## Current Runtime Limitation

The current mobile authentication/profile flow does not yet supply an active
household ID, and receipt/purchase ingestion remains planned. Consequently the
released mobile screen honestly shows setup/no-history states in normal
bootstrap use. The REST endpoint is ready to analyze persisted purchase rows
when a future authenticated purchase workflow supplies a household ID.
