# Product Barcode Camera Capture

## Related Spec

- `specs/product-health-intelligence/overview.md`

## Related ADRs

- `docs/adr/0008-use-provider-abstractions-for-external-services.md`
- `docs/adr/0010-centralize-mobile-design-system.md`
- `docs/adr/0011-model-packaged-product-variants-and-provenance.md`

## Objective

Make the existing Product Barcode Lookup Foundation camera-first and directly
discoverable from Home, while retaining manual barcode entry as an accessible
fallback.

## Context

PantriBox already validates and looks up standard product barcodes through its
backend, but the mobile flow requires users to type them. The existing capture
layer has an image-picker abstraction for future receipt capture but no barcode
decoder. A camera scanner must remain an isolated mobile integration and must
reuse the existing lookup route and report rather than create another product
pipeline.

## Scope

- Add a mobile barcode-scanner adapter under `mobile/lib/core/capture/`.
- Support standard packaged-product barcode formats accepted by the existing
  backend validation.
- Add camera permission declarations for iOS and Android.
- Add a scanner screen that hands one accepted code to the existing Product
  Lookup screen and prevents duplicate detections.
- Add `Scan product` to the existing Home quick-action row.
- Retain manual barcode entry and all current backend contracts.

## Out of Scope

- Product-label image capture, OCR, vision extraction, or image retention.
- Changes to Product persistence, Open Food Facts integration, cache policy, or
  lookup API contracts.
- Health scoring, claims, alternatives, shopping-list health analysis, MCP
  tools, and analytics pipeline implementation.

## Existing Code to Review

- `mobile/lib/core/capture/receipt_image_picker.dart`
- `mobile/lib/features/home/presentation/home_screen.dart`
- `mobile/lib/features/product_intelligence/presentation/scan_hub_screen.dart`
- `mobile/lib/features/product_intelligence/presentation/product_lookup_screen.dart`
- `mobile/lib/app/routing/app_router.dart`

## Implementation Requirements

- Put scanner package integration behind a small `core/capture` abstraction.
- Use the current design-system widgets and routes; do not create a second Scan
  navigation flow.
- Accept only one barcode per scanner presentation and defer all barcode
  validation and lookup decisions to the existing backend service.
- Present clear loading, permission, and unavailable-camera recovery states.
- Do not save, log, upload, or analyze camera frames or product-label images.

## Data Model Impact

None.

## API Impact

None. Camera capture calls the existing
`POST /api/v1/product-intelligence/barcode-lookups` endpoint through the
existing mobile repository.

## Security Considerations

- Request camera permission only when entering the barcode scanner.
- Explain the camera purpose in platform permission text.
- A detected barcode is treated as lookup input, not as analytics payload.

## Testing Requirements

- Widget test Home `Scan product` discoverability and route handoff.
- Widget test manual barcode prefill and automatic lookup handoff.
- Unit test scanner deduplication behavior without a physical camera.
- Run existing backend tests to ensure the unchanged API contract remains valid.

## Acceptance Criteria

- A user can begin Product Health Intelligence from Home or Scan.
- A standard barcode detected by the camera opens the existing structured
  product report flow exactly once.
- Manual barcode entry remains usable if camera permission is unavailable or a
  user chooses not to scan.
- No Product Health Assessment score, label OCR, or unsupported claim judgment
  appears in the experience.

## Validation Commands

```bash
cd mobile && flutter pub get && dart format --output=none --set-exit-if-changed . && flutter analyze && flutter test
cd backend && ruff format --check . && ruff check . && pytest
docker compose config
```

## Risks

- Simulator camera availability is limited and cannot establish physical-device
  scanning quality.
- The selected plugin adds a native dependency and requires iOS/Android camera
  permission configuration.
- The backend remains unavailable for a live end-to-end lookup until local
  Docker storage is available.
