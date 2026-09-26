import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pantribox_mobile/app/theme/pantribox_spacing.dart';
import 'package:pantribox_mobile/shared/extensions/pantribox_theme_extension.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_card.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_primary_button.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_page_app_bar.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_screen_header.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_secondary_button.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_status_chip.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.pantriBoxTheme;

    return Scaffold(
      appBar: const PantriBoxPageAppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(PantriBoxSpacing.lg),
          children: [
            const PantriBoxScreenHeader(
              eyebrow: 'Welcome back',
              title: 'Sign in',
              subtitle:
                  'Authentication providers will be finalized in a dedicated spec. This placeholder keeps the entry flow and accessibility scaffolding ready.',
            ),
            const SizedBox(height: PantriBoxSpacing.xl),
            const PantriBoxStatusChip(
              label: 'Secure session ready',
              tone: PantriBoxStatusTone.info,
            ),
            const SizedBox(height: PantriBoxSpacing.lg),
            PantriBoxCard(
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'name@example.com',
                    ),
                  ),
                  SizedBox(height: PantriBoxSpacing.md),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: PantriBoxSpacing.lg),
            PantriBoxPrimaryButton(
              label: 'Continue',
              icon: Icons.arrow_forward_rounded,
              onPressed: () => context.go('/home'),
            ),
            const SizedBox(height: PantriBoxSpacing.sm),
            PantriBoxSecondaryButton(
              label: 'Forgot password',
              icon: Icons.lock_reset_outlined,
              onPressed: () {},
            ),
            TextButton(
              onPressed: () => context.push('/sign-up'),
              child: Text(
                'Need an account? Sign up',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: palette.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
