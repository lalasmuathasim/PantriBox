# 0001 Use Flutter for Mobile

- Title: Use Flutter for Mobile
- Status: Accepted
- Date: 2026-08-22

## Context

PantriBox needs a single mobile codebase for iOS and Android with strong UI composition, mature tooling, and support for native platform conventions.

## Decision

Use Flutter and Dart for the mobile application.

## Alternatives Considered

- Native iOS and Android applications
- React Native
- Kotlin Multiplatform

## Consequences

- Shared feature and design-system implementation across iOS and Android
- Flutter-specific CI, testing, and state-management conventions
- Platform integration must still respect native behavior where appropriate

## Related Specs / PRPs

- `specs/product-foundation/overview.md`

