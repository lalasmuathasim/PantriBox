# Mobile Back Navigation

## Related Spec

- `specs/mobile-navigation/overview.md`
- `specs/mobile-design-refresh/overview.md`

## Related ADRs

- `docs/adr/0010-centralize-mobile-design-system.md`

## Objective

Remove navigation traps from secondary Flutter screens by using one shared,
stack-aware back affordance and restoring `push` navigation for reversible
transitions.

## Scope

- Add a shared `PantriBoxPageAppBar` with a small platform-aware back control.
- Apply it to authentication, shopping-list, receipt, product lookup, and
  barcode capture screens.
- Change reversible `go` and `replace` calls to `push` or `pop`.
- Retain `go('/home')` for successful authentication completion and root-tab
  navigation.

## Out of Scope

- Root bottom-navigation screens, new auth behavior, arbitrary back fallbacks,
  or interception of native back gestures.

## Testing Requirements

- Onboarding to Sign Up returns to onboarding.
- Sign In to Sign Up returns to Sign In.
- Nested list, receipt, and product flows return to their immediate parent.
- Root destinations do not render a back button.

## Validation Commands

```bash
cd mobile && dart format --output=none --set-exit-if-changed lib test && flutter analyze && flutter test
```
