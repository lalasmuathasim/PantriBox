# PantriBox Product Vision

## Purpose

PantriBox helps households make better grocery decisions by combining shopping intent, purchase evidence, and price intelligence.

## Core principle

Receipts are a key data source, not just expense records.

```text
Receipt
  ↓
Purchase
  ↓
Receipt Items
  ↓
Normalized Products
  ↓
Price Observations
  ↓
Price Intelligence
  ↓
Shopping Optimization
  ↓
Household Consumption Intelligence
  ↓
Nutrition Intelligence
```

## Initial journey

```text
Create Shopping List
        ↓
Add Products
        ↓
Compare / Optimize
        ↓
Purchase
        ↓
Scan Receipt
        ↓
Review Extracted Items
        ↓
Confirm Purchase
        ↓
Update Purchase History
        ↓
Update Price Observations
```

Manual purchase entry remains an important fallback path.

## Product health intelligence

PantriBox can enrich a canonical packaged Product from a barcode with source-backed package, nutrition, and ingredient information. This supports future health-aware shopping while keeping product information separate from household consumption claims.

## Household nutrition insights

Household Nutrition Insights analyzes source-backed nutrition information
represented in identified grocery purchases. It communicates grocery-basket
coverage and data completeness, not individual food intake or medical status.
`purchase != consumption`: purchases do not prove who ate an item, how much
was eaten, or whether it was wasted. Quantitative adequacy requires an approved,
versioned nutrition-reference methodology.

## Future-facing constraints

- Receipt descriptions are not canonical product identities.
- A purchase does not prove household consumption.
- AI should orchestrate deterministic tools instead of becoming the source of truth for prices, routes, or optimization.
