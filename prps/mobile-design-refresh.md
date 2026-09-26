# Mobile Design Refresh

## Related Spec

- `specs/mobile-design-refresh/overview.md`
- `specs/mobile-design-refresh/acceptance-criteria.md`

## Related ADRs

- `docs/adr/0001-use-flutter-for-mobile.md`
- `docs/adr/0004-use-riverpod-for-flutter-state-management.md`
- `docs/adr/0010-centralize-mobile-design-system.md`

## Objective

Introduce a substantially more polished PantriBox mobile design system while preserving all current functionality and keeping the visual system easy to revert or iterate.

## Context

The bootstrap UI currently proves architecture and navigation but uses intentionally basic styling. The requested redesign should improve polish, hierarchy, and native feel without turning the feature screens into style-heavy one-offs.

## Scope

- Add a reversible theme architecture for legacy and refreshed styling
- Introduce refined tokens for color, spacing, radius, shadow, and typography
- Improve reusable UI components such as cards, buttons, section headers, and navigation
- Restyle the current mobile placeholder screens using the shared design system

## Out of Scope

- Business logic changes
- New backend integration work
- New product workflows
- Dark mode redesign
- Permanent experimentation infrastructure beyond a lightweight development switch

## Existing Code to Review

- `mobile/lib/app/theme/*`
- `mobile/lib/shared/widgets/*`
- `mobile/lib/core/widgets/pantribox_shell.dart`
- `mobile/lib/features/**/presentation/*.dart`

## Implementation Requirements

- Preserve the current theme implementation rather than replacing it destructively
- Keep visual values centralized behind design tokens and shared components
- Respect safe areas, text scaling, touch targets, and native back behavior
- Avoid scattering color and spacing literals throughout feature widgets
- Keep the refreshed look consumer-mobile oriented rather than dashboard/bootstrap styled

## Data Model Impact

- None

## API Impact

- None

## Security Considerations

- No change to auth, token handling, or backend communication
- No new sensitive data exposure in the UI layer

## Testing Requirements

- `dart format lib test`
- `flutter analyze`
- `flutter test`
- Launch in simulator if available

## Acceptance Criteria

- The refreshed theme is active and visibly more polished
- The legacy theme still exists in code
- Shared components drive the redesign
- Updated screens render without overflows in standard widget tests

## Validation Commands

- `cd mobile && dart format lib test`
- `cd mobile && flutter analyze`
- `cd mobile && flutter test`
- `cd mobile && flutter run -d <simulator>`

## Risks

- Over-styling placeholder screens instead of improving the design system
- Introducing hardcoded screen-level tokens that make future design changes expensive
- Causing layout overflow at large text scales if the new visual density is not checked carefully

