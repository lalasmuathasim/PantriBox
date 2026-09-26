import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pantribox_mobile/app/bootstrap/pantribox_app.dart';
import 'package:pantribox_mobile/app/theme/pantribox_theme_v2.dart';
import 'package:pantribox_mobile/core/capture/product_barcode_scanner.dart';
import 'package:pantribox_mobile/features/home/application/home_demo_fixtures.dart';
import 'package:pantribox_mobile/features/home/application/home_overview.dart';
import 'package:pantribox_mobile/features/product_intelligence/presentation/product_barcode_scan_screen.dart';
import 'package:pantribox_mobile/shared/extensions/pantribox_theme_extension.dart';

void main() {
  Future<void> pumpPantriBoxApp(
    WidgetTester tester, {
    String initialLocation = '/onboarding',
    HomeOverview? homeOverview,
  }) {
    return tester.pumpWidget(
      ProviderScope(
        overrides: homeOverview == null
            ? const []
            : [homeOverviewProvider.overrideWithValue(homeOverview)],
        child: PantriBoxApp(initialLocation: initialLocation),
      ),
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
      '/home': 'What would you like to do?',
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

  testWidgets('home exposes product checking through its primary workflows', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await pumpPantriBoxApp(tester, initialLocation: '/home');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Check a product'));
    await tester.pumpAndSettle();

    expect(find.text('Scan a packaged food'), findsOneWidget);
  });

  testWidgets('new-user Home foregrounds the three primary workflows', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await pumpPantriBoxApp(
      tester,
      initialLocation: '/home',
      homeOverview: const HomeOverview(greeting: 'Good evening'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Plan your shopping'), findsOneWidget);
    expect(find.text('Scan a receipt'), findsOneWidget);
    expect(find.text('Check a product'), findsOneWidget);
    expect(find.text('Your household insights'), findsOneWidget);
    expect(find.text('₹0'), findsNothing);
  });

  testWidgets('Home workflow cards open their specific routes directly', (
    tester,
  ) async {
    const newUser = HomeOverview(greeting: 'Good evening');
    await tester.binding.setSurfaceSize(const Size(800, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await pumpPantriBoxApp(
      tester,
      initialLocation: '/home',
      homeOverview: newUser,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Plan your shopping'));
    await tester.pumpAndSettle();
    expect(find.text('Create shopping list'), findsOneWidget);

    await pumpPantriBoxApp(
      tester,
      initialLocation: '/home',
      homeOverview: newUser,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Scan a receipt'));
    await tester.pumpAndSettle();
    expect(find.text('Scan receipt'), findsWidgets);

    await pumpPantriBoxApp(
      tester,
      initialLocation: '/home',
      homeOverview: newUser,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Check a product'));
    await tester.pumpAndSettle();
    expect(find.text('Scan a packaged food'), findsOneWidget);
  });

  testWidgets('returning-user Home resumes an active shopping list', (
    tester,
  ) async {
    await pumpPantriBoxApp(tester, initialLocation: '/home');
    await tester.pumpAndSettle();

    expect(find.text('Continue shopping'), findsOneWidget);
    expect(find.text('Weekend stock-up · 8 items · 3 checked'), findsOneWidget);
    expect(find.text('Start a new list'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('₹18,240'), 250);
    expect(find.text('₹18,240'), findsOneWidget);
    expect(find.text('₹1,420'), findsOneWidget);
  });

  testWidgets('secondary workflows stack on a narrow display', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await pumpPantriBoxApp(tester, initialLocation: '/home');
    await tester.pumpAndSettle();

    final workflows = tester.widget<Flex>(
      find.byKey(const Key('home-secondary-workflows')),
    );
    expect(workflows.direction, Axis.vertical);
    expect(tester.takeException(), isNull);
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
