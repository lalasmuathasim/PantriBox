# Mobile Navigation Overview

STATUS: ACTIVE

## Objective

Provide predictable, native-feeling back navigation for secondary PantriBox
screens without adding back affordances to primary bottom-navigation
destinations.

## Rules

- Reversible navigation uses the existing GoRouter stack through `push` and
  `pop`.
- Successful authentication may replace the entry flow with Home.
- A secondary screen shows a subtle platform-appropriate back affordance only
  when a previous route exists.
- Root tabs, onboarding, and direct deep links do not invent a back
  destination when no route can be popped.
- Android system back and iOS interactive back behavior remain owned by the
  navigator.

## Included

- Authentication transitions between onboarding, Sign In, and Sign Up
- Shopping-list creation and detail routes
- Receipt, product lookup, and barcode capture routes
- Shared app-bar back control and navigation tests

## Excluded

- Authentication implementation, root navigation redesign, route guards, and
  arbitrary fallback destinations for direct deep links.
