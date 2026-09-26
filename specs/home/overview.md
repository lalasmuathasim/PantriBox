# Home Overview

STATUS: ACTIVE

## Objective

Make Home the action-first starting point for PantriBox. A household should
immediately understand how to plan shopping, track a purchase, or check a
packaged product before encountering secondary analytics.

## Included

- Compact operational greeting with notification affordance
- Plan, Track, and Check workflow cards in the first viewport
- Direct routes to shopping-list creation or continuation, receipt capture, and
  product intelligence
- Conditional active-list continuation and compact household metrics
- Intentional household-insights empty state when no data is available
- Recent purchase activity below the primary workflows

## Excluded

- New backend, data-model, analytics, or API functionality
- Changes to the bottom navigation or generic Scan hub
- Receipt capture, shopping-list CRUD, Product Health scoring, or label OCR

## Product Rules

- The three primary workflows are Plan your shopping, Scan a receipt, and
  Check a product; Home must not become a catalog of every feature.
- Known-intent Home actions deep-link directly to their relevant workflows.
- Monthly spending and savings must never precede the primary action cards.
- Empty household data is explained with a useful action, never a primary
  zero-value dashboard.
- Active work is offered as a continuation only when it exists.

## Acceptance Criteria

- A normal phone viewport shows all three workflows before household analytics.
- Plan your shopping is the visually emphasized action.
- Receipt and product actions open their specific capture flows in one tap.
- Existing active-list, spending, savings, and recent-purchase information
  remains available when fixture or future domain data supplies it.
- Small screens and increased text scaling stack secondary action cards rather
  than clipping content.
