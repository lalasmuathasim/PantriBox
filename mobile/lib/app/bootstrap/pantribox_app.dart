import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pantribox_mobile/app/routing/app_router.dart';
import 'package:pantribox_mobile/app/theme/pantribox_theme.dart';
import 'package:pantribox_mobile/app/theme/pantribox_theme_v2.dart';
import 'package:pantribox_mobile/app/theme/pantribox_theme_variant.dart';

class PantriBoxApp extends ConsumerWidget {
  const PantriBoxApp({super.key, this.initialLocation = '/onboarding'});

  final String initialLocation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = createRouter(ref, initialLocation: initialLocation);
    final theme = switch (PantriBoxThemeVariant.current()) {
      PantriBoxThemeVariant.legacy => PantriBoxTheme.light(),
      PantriBoxThemeVariant.v2 => PantriBoxThemeV2.light(),
    };

    return MaterialApp.router(
      title: 'PantriBox',
      theme: theme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
