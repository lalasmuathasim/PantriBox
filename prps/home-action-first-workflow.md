# Home Action-First Workflow

## Related Spec

- `specs/home/overview.md`
- `specs/mobile-design-refresh/overview.md`

## Related ADRs

- `docs/adr/0010-centralize-mobile-design-system.md`

## Objective

Restructure the existing Home screen around PantriBox's three principal user
jobs: plan shopping, track purchases through receipt capture, and check a
packaged product.

## Context

Home currently makes a large monthly-spending metric its primary content. The
underlying values and routes are already available as fixture-backed
presentation data, but the first viewport does not clearly explain where a new
user should begin.

## Scope

- Add a generic shared workflow-card component using current theme tokens.
- Simplify the Home greeting and keep the notification affordance.
- Make Plan the primary visual action and make its active-list state resumable.
- Deep-link receipt and product actions to their existing routes.
- Render compact populated household metrics or an intentional empty state.
- Add Home presentation and route tests, including narrow/large-text layouts.

## Out of Scope

- Analytics infrastructure. The intended future event names are `home_viewed`,
  `plan_shopping_selected`, `scan_receipt_selected`, `check_product_selected`,
  `continue_shopping_selected`, and `household_insights_selected`.
- Backend/domain changes, fake analytics, or changes to existing routes.
- New Product Health Intelligence capabilities, receipt capture logic, or
  shopping-list behavior.

## Existing Code to Review

- `mobile/lib/features/home/application/home_overview.dart`
- `mobile/lib/features/home/application/home_demo_fixtures.dart`
- `mobile/lib/features/home/presentation/home_screen.dart`
- `mobile/lib/shared/widgets/pantribox_card.dart`
- `mobile/lib/shared/widgets/pantribox_metric_card.dart`
- `mobile/lib/app/routing/app_router.dart`

## Implementation Requirements

- Use `PantriBoxCard`, current typography, spacing, and semantic palette values.
- Keep all workflow cards entirely tappable and give them accessible semantic
  labels.
- Reuse existing GoRouter routes with no intermediary Scan hub for known intent.
- Preserve metrics and recent activity as secondary content.
- Support empty and populated fixture states without zero-value metric cards.

## Data Model Impact

None. Expand only the fixture/presentation `HomeOverview` shape needed to
express optional household data and active-list completion.

## API Impact

None.

## Testing Requirements

- Verify all three workflows render and route correctly.
- Verify active-list continuation and new-list affordance.
- Verify populated household metrics and empty household insights.
- Verify secondary cards stack when available width or text scale is constrained.

## Acceptance Criteria

- Satisfy every criterion in `specs/home/overview.md`.

## Validation Commands

```bash
cd mobile && dart format --output=none --set-exit-if-changed lib test && flutter analyze && flutter test
```

## Risks

- Home values are fixtures until a future domain-backed Home query exists.
- Analytics events are specified but deliberately not emitted until the project
  has an approved analytics implementation.
