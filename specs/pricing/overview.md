# Pricing Spec

STATUS: PLANNED

Future work will define price observation freshness, source handling, confidence metadata, price history, and comparison behavior.

## Implemented Data Foundation

`price_observations` is timestamped historical evidence with source,
confidence, quantity/unit, product and package-variant references, optional
purchase-item/store/location links, and price/unit-price values. Product and
location history indexes are present. No comparison API, freshness policy, or
optimizer is implemented yet.
