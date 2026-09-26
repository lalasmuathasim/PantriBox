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

## Future-facing constraints

- Receipt descriptions are not canonical product identities.
- A purchase does not prove household consumption.
- AI should orchestrate deterministic tools instead of becoming the source of truth for prices, routes, or optimization.

