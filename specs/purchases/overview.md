# Purchases Spec

STATUS: PLANNED

Future work will define manual purchase entry, purchase history, receipt-linked purchases, and price observation generation.

## Nutrition Integration

The Household Nutrition Insights service may read persisted purchase items for
a selected household/date range. This does not activate purchase ingestion:
until this spec is implemented, live installations have no purchase-history API
or receipt-confirmation workflow feeding those rows. Purchase evidence remains
grocery-basket evidence only and must not be represented as consumption.
