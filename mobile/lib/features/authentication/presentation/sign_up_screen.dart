import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pantribox_mobile/app/theme/pantribox_spacing.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_card.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_primary_button.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_page_app_bar.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_screen_header.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_status_chip.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PantriBoxPageAppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(PantriBoxSpacing.lg),
          children: [
            const PantriBoxScreenHeader(
              eyebrow: 'Start your household setup',
              title: 'Create account',
              subtitle:
                  'Account creation is not available in this development build. Use a configured development account to sign in.',
            ),
            const SizedBox(height: PantriBoxSpacing.xl),
            const PantriBoxStatusChip(
              label: 'Designed for households',
              tone: PantriBoxStatusTone.primary,
            ),
            const SizedBox(height: PantriBoxSpacing.lg),
            PantriBoxCard(
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Full name'),
                  ),
                  SizedBox(height: PantriBoxSpacing.md),
                  TextField(decoration: InputDecoration(labelText: 'Email')),
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
              label: 'Return to sign in',
              icon: Icons.login_rounded,
              onPressed: () => context.go('/sign-in'),
            ),
          ],
        ),
      ),
    );
  }
}
