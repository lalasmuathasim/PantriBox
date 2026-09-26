import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pantribox_mobile/app/theme/pantribox_radius.dart';
import 'package:pantribox_mobile/app/theme/pantribox_spacing.dart';
import 'package:pantribox_mobile/core/capture/product_barcode_scanner.dart';
import 'package:pantribox_mobile/shared/extensions/pantribox_theme_extension.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_card.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_screen_header.dart';

typedef ProductBarcodeScannerBuilder =
    Widget Function(ProductBarcodeDetected onBarcodeDetected);

class ProductBarcodeScanScreen extends StatefulWidget {
  const ProductBarcodeScanScreen({
    super.key,
    this.scannerBuilder,
    this.onBarcodeAccepted,
  });

  final ProductBarcodeScannerBuilder? scannerBuilder;
  final ValueChanged<String>? onBarcodeAccepted;

  @override
  State<ProductBarcodeScanScreen> createState() =>
      _ProductBarcodeScanScreenState();
}

class _ProductBarcodeScanScreenState extends State<ProductBarcodeScanScreen> {
  bool _hasNavigated = false;

  void _handleBarcodeDetected(String barcode) {
    if (_hasNavigated) {
      return;
    }
    _hasNavigated = true;
    if (widget.onBarcodeAccepted case final onBarcodeAccepted?) {
      onBarcodeAccepted(barcode);
      return;
    }
    context.replace(
      '/scan/product?barcode=${Uri.encodeQueryComponent(barcode)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.pantriBoxTheme;
    final scannerBuilder =
        widget.scannerBuilder ??
        (onBarcodeDetected) =>
            ProductBarcodeScannerPreview(onBarcodeDetected: onBarcodeDetected);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            PantriBoxSpacing.lg,
            PantriBoxSpacing.md,
            PantriBoxSpacing.lg,
            PantriBoxSpacing.xxl,
          ),
          children: [
            const PantriBoxScreenHeader(
              eyebrow: 'Product intelligence',
              title: 'Scan a product barcode',
              subtitle:
                  'Hold the barcode inside the frame. PantriBox will look up the available product information.',
            ),
            const SizedBox(height: PantriBoxSpacing.xl),
            PantriBoxCard(
              padding: EdgeInsets.zero,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(PantriBoxRadius.lg),
                child: AspectRatio(
                  aspectRatio: 0.86,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      scannerBuilder(_handleBarcodeDetected),
                      IgnorePointer(
                        child: Center(
                          child: Container(
                            width: 244,
                            height: 156,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(
                                PantriBoxRadius.md,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.infinity,
                          color: const Color(0x99000000),
                          padding: const EdgeInsets.all(PantriBoxSpacing.md),
                          child: Text(
                            'Only the barcode is used for lookup. Camera frames are not stored.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: PantriBoxSpacing.lg),
            TextButton.icon(
              onPressed: () => context.replace('/scan/product'),
              icon: Icon(Icons.keyboard_alt_outlined, color: palette.primary),
              label: const Text('Enter the barcode manually instead'),
            ),
          ],
        ),
      ),
    );
  }
}
