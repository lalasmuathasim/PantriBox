import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

typedef ProductBarcodeDetected = void Function(String barcode);

/// Accepts the first usable barcode from a camera session to prevent duplicate lookups.
class ProductBarcodeCaptureGate {
  bool _hasAcceptedBarcode = false;

  String? accept(Iterable<String?> values) {
    if (_hasAcceptedBarcode) {
      return null;
    }

    for (final value in values) {
      final barcode = value?.trim();
      if (barcode != null && barcode.isNotEmpty) {
        _hasAcceptedBarcode = true;
        return barcode;
      }
    }
    return null;
  }
}

/// Isolates the scanner package behind PantriBox's capture layer.
class ProductBarcodeScannerPreview extends StatefulWidget {
  const ProductBarcodeScannerPreview({
    required this.onBarcodeDetected,
    super.key,
  });

  final ProductBarcodeDetected onBarcodeDetected;

  @override
  State<ProductBarcodeScannerPreview> createState() =>
      _ProductBarcodeScannerPreviewState();
}

class _ProductBarcodeScannerPreviewState
    extends State<ProductBarcodeScannerPreview> {
  final _captureGate = ProductBarcodeCaptureGate();
  final _controller = MobileScannerController(
    formats: const [
      BarcodeFormat.ean8,
      BarcodeFormat.ean13,
      BarcodeFormat.upcA,
      BarcodeFormat.upcE,
      BarcodeFormat.itf14,
    ],
  );

  @override
  void dispose() {
    unawaited(_controller.dispose());
    super.dispose();
  }

  void _handleCapture(BarcodeCapture capture) {
    final barcode = _captureGate.accept(
      capture.barcodes.map((detected) => detected.rawValue),
    );
    if (barcode == null) {
      return;
    }

    unawaited(_controller.stop());
    widget.onBarcodeDetected(barcode);
  }

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: _controller,
      onDetect: _handleCapture,
      errorBuilder: (context, error) => _ScannerUnavailableState(
        message:
            error.errorDetails?.message ??
            'PantriBox could not start the camera. You can enter the barcode instead.',
      ),
      placeholderBuilder: (context) => const ColoredBox(
        color: Color(0xFF1C211E),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _ScannerUnavailableState extends StatelessWidget {
  const _ScannerUnavailableState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF1C211E),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
