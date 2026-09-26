import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pantribox_mobile/core/widgets/pantribox_shell.dart';
import 'package:pantribox_mobile/features/authentication/presentation/sign_in_screen.dart';
import 'package:pantribox_mobile/features/authentication/presentation/sign_up_screen.dart';
import 'package:pantribox_mobile/features/home/presentation/home_screen.dart';
import 'package:pantribox_mobile/features/insights/presentation/insights_screen.dart';
import 'package:pantribox_mobile/features/onboarding/presentation/onboarding_screen.dart';
import 'package:pantribox_mobile/features/profile/presentation/profile_screen.dart';
import 'package:pantribox_mobile/features/product_intelligence/presentation/product_lookup_screen.dart';
import 'package:pantribox_mobile/features/product_intelligence/presentation/scan_hub_screen.dart';
import 'package:pantribox_mobile/features/receipt_scan/presentation/receipt_scan_screen.dart';
import 'package:pantribox_mobile/features/shopping_lists/presentation/create_shopping_list_screen.dart';
import 'package:pantribox_mobile/features/shopping_lists/presentation/shopping_list_detail_screen.dart';
import 'package:pantribox_mobile/features/shopping_lists/presentation/shopping_lists_screen.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_error_state.dart';

GoRouter createRouter(WidgetRef ref, {String initialLocation = '/onboarding'}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) =>
            const PantriBoxShell(currentLocation: '/home', child: HomeScreen()),
      ),
      GoRoute(
        path: '/lists',
        builder: (context, state) => const PantriBoxShell(
          currentLocation: '/lists',
          child: ShoppingListsScreen(),
        ),
        routes: [
          GoRoute(
            path: 'create',
            builder: (context, state) => const CreateShoppingListScreen(),
          ),
          GoRoute(
            path: ':listId',
            builder: (context, state) => ShoppingListDetailScreen(
              listId: state.pathParameters['listId']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/scan',
        builder: (context, state) => const PantriBoxShell(
          currentLocation: '/scan',
          child: ScanHubScreen(),
        ),
      ),
      GoRoute(
        path: '/scan/receipt',
        builder: (context, state) => const ReceiptScanScreen(),
      ),
      GoRoute(
        path: '/scan/product',
        builder: (context, state) => const ProductLookupScreen(),
      ),
      GoRoute(
        path: '/insights',
        builder: (context, state) => const PantriBoxShell(
          currentLocation: '/insights',
          child: InsightsScreen(),
        ),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const PantriBoxShell(
          currentLocation: '/profile',
          child: ProfileScreen(),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: PantriBoxErrorState(
          title: 'Page not found',
          message:
              'The requested route does not exist in the current bootstrap.',
          primaryActionLabel: 'Go home',
          onPrimaryAction: () => context.go('/home'),
        ),
      ),
    ),
  );
}
