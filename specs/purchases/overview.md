# Purchases Spec

STATUS: PLANNED

Future work will define manual purchase entry, purchase history, receipt-linked purchases, and price observation generation.

## Implemented Data Foundation

Purchase records now retain a household, optional receipt/store/location,
recording user, purchase source, timestamp, and currency. Purchase items retain
raw descriptions, canonical product/variant links, quantity/unit, price,
unit price, product-match source/confidence, optional correcting user, and a
source line reference. These facts are not produced by shopping-list items.

The ingestion, review, and mutation APIs remain planned.

## Nutrition Integration

The Household Nutrition Insights service may read persisted purchase items for
a selected household/date range. This does not activate purchase ingestion:
until this spec is implemented, live installations have no purchase-history API
or receipt-confirmation workflow feeding those rows. Purchase evidence remains
grocery-basket evidence only and must not be represented as consumption.
