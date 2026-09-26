import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pantribox_mobile/app/bootstrap/pantribox_app.dart';
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
      '/scan': 'Turn receipts into price intelligence',
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
}
