# 0010 Centralize Mobile Design System

- Title: Centralize Mobile Design System
- Status: Accepted
- Date: 2026-08-23

## Context

PantriBox needs a more polished mobile presentation layer, but the repository must keep visual changes reversible and low-risk. Scattering colors, spacing, and component styling throughout individual screens would make future restyling expensive and make it harder to revert to an earlier direction.

## Decision

Keep the original mobile theme implementation intact and introduce refreshed styling through a centralized design-system layer with isolated theme tokens, shared components, and a lightweight development-oriented theme switch.

## Alternatives Considered

- Replace the existing theme in place with no preserved legacy path
- Restyle each screen directly with local widget styling
- Introduce a large runtime theming framework for experimentation

## Consequences

- Most visual changes live in `lib/app/theme/`, `lib/shared/widgets/`, and shared page-shell components
- Feature screens can adopt a new look with minimal logic changes
- Reverting to the prior direction is straightforward because the legacy theme remains available
- Additional shared widgets and tokens must be maintained carefully to avoid over-abstraction

## Related Specs / PRPs

- `specs/mobile-design-refresh/overview.md`
- `prps/mobile-design-refresh.md`

