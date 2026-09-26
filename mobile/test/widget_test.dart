import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pantribox_mobile/app/bootstrap/pantribox_app.dart';
import 'package:pantribox_mobile/app/theme/pantribox_theme_v2.dart';
import 'package:pantribox_mobile/core/capture/product_barcode_scanner.dart';
import 'package:pantribox_mobile/features/product_intelligence/presentation/product_barcode_scan_screen.dart';
import 'package:pantribox_mobile/shared/extensions/pantribox_theme_extension.dart';

void main() {
  Future<void> pumpPantriBoxApp(
    WidgetTester tester, {
    String initialLocation = '/onboarding',
  }) {
    return tester.pumpWidget(
      ProviderScope(child: PantriBoxApp(initialLocation: initialLocation)),
    );
  }

  testWidgets('app starts on onboarding screen', (tester) async {
    await pumpPantriBoxApp(tester);
    await tester.pumpAndSettle();

    expect(find.text('PantriBox'), findsOneWidget);
    expect(find.textContaining('Plan better grocery trips'), findsOneWidget);
  });

  testWidgets('bottom navigation opens lists screen', (tester) async {
    await pumpPantriBoxApp(tester, initialLocation: '/home');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Lists'));
    await tester.pumpAndSettle();

    expect(find.text('Shopping lists'), findsOneWidget);
  });

  testWidgets('key routes render under the refreshed theme', (tester) async {
    const routeExpectations = <String, String>{
      '/home': 'Monthly grocery spending',
      '/lists': 'Shopping lists',
      '/scan': 'What would you like to scan?',
      '/insights': 'Preview containers',
      '/profile': 'PantriBox Household',
      '/sign-in': 'Sign in',
      '/sign-up': 'Create account',
    };

    for (final entry in routeExpectations.entries) {
      await pumpPantriBoxApp(tester, initialLocation: entry.key);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text(entry.value), findsOneWidget);
    }
  });

  testWidgets('theme exposes PantriBox background color', (tester) async {
    await pumpPantriBoxApp(tester, initialLocation: '/home');
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(Scaffold).first);
    expect(
      Theme.of(context).scaffoldBackgroundColor,
      context.pantriBoxTheme.background,
    );
  });

  testWidgets('scan hub opens product lookup', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await pumpPantriBoxApp(tester, initialLocation: '/scan');
    await tester.pumpAndSettle();

    final productLookupButton = find.widgetWithText(
      ElevatedButton,
      'Look up product',
    );
    await tester.tap(productLookupButton);
    await tester.pumpAndSettle();

    expect(find.text('Scan a packaged food'), findsOneWidget);
  });

  testWidgets('home exposes scan product through its quick actions', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await pumpPantriBoxApp(tester, initialLocation: '/home');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Scan product'));
    await tester.pumpAndSettle();

    expect(find.text('Scan a packaged food'), findsOneWidget);
  });

  test('barcode capture gate accepts only the first usable barcode', () {
    final gate = ProductBarcodeCaptureGate();

    expect(gate.accept([null, '', '8901234567890']), '8901234567890');
    expect(gate.accept(['0123456789012']), isNull);
  });

  testWidgets('barcode scanner screen hands a detected barcode off once', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final capturedBarcodes = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: PantriBoxThemeV2.light(),
        home: ProductBarcodeScanScreen(
          scannerBuilder: (onBarcodeDetected) => Center(
            child: FilledButton(
              onPressed: () => onBarcodeDetected('8901234567890'),
              child: const Text('Simulate barcode detection'),
            ),
          ),
          onBarcodeAccepted: capturedBarcodes.add,
        ),
      ),
    );

    await tester.tap(find.text('Simulate barcode detection'));
    await tester.tap(find.text('Simulate barcode detection'));

    expect(capturedBarcodes, ['8901234567890']);
  });
}
