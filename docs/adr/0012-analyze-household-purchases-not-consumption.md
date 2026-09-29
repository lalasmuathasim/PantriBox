# 0012 Analyze Household Purchases, Not Consumption

- Title: Analyze Household Purchases, Not Consumption
- Status: Accepted
- Date: 2026-09-29

## Context

PantriBox can accumulate receipt, purchase, and product information that is
useful for understanding the food entering a household. That evidence is not
enough to establish individual dietary intake: products can be shared, wasted,
stored, consumed outside the observed period, or not consumed by the household
at all. PantriBox also does not yet have an approved nutrient-reference
methodology for its initial Indian market.

## Decision

Introduce Household Nutrition Insights as a deterministic analysis of
**household grocery purchase coverage**. It must not make diagnoses,
individual-intake claims, or nutrient-deficiency claims.

The analysis service aggregates only source-backed nutrition facts associated
with identified purchase products and reports data completeness separately.
Unknown values remain unknown. It records the nutrition data provenance and
the configured reference-methodology version with every result.

Quantitative adequacy, targets, percentages, and gap-derived food
recommendations require an explicitly approved, versioned nutrition-reference
methodology. Until one is configured, the service returns a transparent
not-production-ready methodology state rather than fabricating thresholds.

REST endpoints and future MCP tools use the same household, aggregation,
reference, insight, and recommendation services. An LLM may later explain or
rank deterministic outputs, but cannot calculate totals, invent deficiencies,
or alter coverage results.

## Alternatives Considered

- Infer individual intake by dividing household purchases by member count
- Use model-generated nutrient targets and recommendations
- Treat missing nutrition facts as zero
- Build a separate nutrition-specific product model

## Consequences

- The product can safely communicate observed grocery-basket representation and
  data quality before scientific reference data is approved.
- Household member attributes stay minimal and optional until a reference
  methodology demonstrably requires them.
- Purchase items need a reliable canonical product or variant link and a usable
  quantity before their declared values can contribute to nutrient totals.
- Future pantry, meal, and consumption evidence can be added without changing
  the meaning of historical purchase-based insights.

## Related Specs / PRPs

- `specs/household-nutrition-insights/overview.md`
- `specs/product-health-intelligence/overview.md`
- `prps/household-nutrition-insights-phase-1.md`
- `docs/adr/0011-model-packaged-product-variants-and-provenance.md`
- `docs/adr/0007-use-service-layer-shared-by-rest-and-mcp.md`
