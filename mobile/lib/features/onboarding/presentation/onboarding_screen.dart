import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pantribox_mobile/app/theme/pantribox_radius.dart';
import 'package:pantribox_mobile/app/theme/pantribox_spacing.dart';
import 'package:pantribox_mobile/shared/extensions/pantribox_theme_extension.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_card.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_primary_button.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_secondary_button.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_status_chip.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.pantriBoxTheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(PantriBoxSpacing.lg),
          children: [
            const SizedBox(height: PantriBoxSpacing.lg),
            const PantriBoxStatusChip(
              label: 'Structured shopping intelligence',
              tone: PantriBoxStatusTone.primary,
            ),
            const SizedBox(height: PantriBoxSpacing.xl),
            PantriBoxCard(
              backgroundColor: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      gradient: palette.heroGradient,
                      borderRadius: BorderRadius.circular(PantriBoxRadius.lg),
                    ),
                    child: Icon(
                      Icons.shopping_basket_outlined,
                      size: 42,
                      color: palette.primary,
                    ),
                  ),
                  const SizedBox(height: PantriBoxSpacing.xl),
                  Text('PantriBox', style: theme.textTheme.displayMedium),
                  const SizedBox(height: PantriBoxSpacing.sm),
                  Text(
                    'Plan better grocery trips with shopping lists, receipt capture, and future-ready price intelligence.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                  const SizedBox(height: PantriBoxSpacing.xl),
                  const _OnboardingPoint(
                    title: 'Track spending with context',
                    subtitle:
                        'Receipts become verified purchases and future price observations.',
                  ),
                  const SizedBox(height: PantriBoxSpacing.md),
                  const _OnboardingPoint(
                    title: 'Prepare for smarter shopping',
                    subtitle:
                        'Optimization stays structured so recommendations can be trusted later.',
                  ),
                  const SizedBox(height: PantriBoxSpacing.md),
                  const _OnboardingPoint(
                    title: 'Built for households',
                    subtitle:
                        'Designed for shared shopping habits, not just one-off expenses.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: PantriBoxSpacing.xl),
            PantriBoxPrimaryButton(
              label: 'Create account',
              onPressed: () => context.push('/sign-up'),
            ),
            const SizedBox(height: PantriBoxSpacing.sm),
            PantriBoxSecondaryButton(
              label: 'Sign in',
              onPressed: () => context.push('/sign-in'),
            ),
            const SizedBox(height: PantriBoxSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPoint extends StatelessWidget {
  const _OnboardingPoint({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final palette = context.pantriBoxTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: palette.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: PantriBoxSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: palette.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
