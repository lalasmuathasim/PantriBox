import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pantribox_mobile/app/theme/pantribox_radius.dart';
import 'package:pantribox_mobile/app/theme/pantribox_spacing.dart';
import 'package:pantribox_mobile/shared/extensions/pantribox_theme_extension.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_card.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_primary_button.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_screen_header.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_secondary_button.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_status_chip.dart';

class ScanHubScreen extends StatelessWidget {
  const ScanHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.pantriBoxTheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          PantriBoxSpacing.lg,
          PantriBoxSpacing.md,
          PantriBoxSpacing.lg,
          120,
        ),
        children: [
          const PantriBoxScreenHeader(
            eyebrow: 'PantriBox intelligence',
            title: 'What would you like to scan?',
            subtitle:
                'Capture purchase evidence or look up what a packaged food contains.',
          ),
          const SizedBox(height: PantriBoxSpacing.xl),
          _ScanOptionCard(
            icon: Icons.document_scanner_outlined,
            title: 'Receipt',
            description:
                'Capture a receipt to build purchase history and price intelligence.',
            accent: palette.info,
            action: PantriBoxSecondaryButton(
              label: 'Scan receipt',
              icon: Icons.receipt_long_outlined,
              onPressed: () => context.push('/scan/receipt'),
            ),
          ),
          const SizedBox(height: PantriBoxSpacing.md),
          _ScanOptionCard(
            icon: Icons.inventory_2_outlined,
            title: 'Product',
            description:
                'Look up product nutrition and ingredients from a packaged-food barcode.',
            accent: palette.primary,
            action: PantriBoxPrimaryButton(
              label: 'Look up product',
              icon: Icons.qr_code_rounded,
              onPressed: () => context.push('/scan/product'),
            ),
          ),
          const SizedBox(height: PantriBoxSpacing.xl),
          const PantriBoxStatusChip(
            label: 'Information, not a health score',
            tone: PantriBoxStatusTone.neutral,
            icon: Icons.info_outline_rounded,
          ),
        ],
      ),
    );
  }
}

class _ScanOptionCard extends StatelessWidget {
  const _ScanOptionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.accent,
    required this.action,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color accent;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return PantriBoxCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(PantriBoxRadius.md),
            ),
            child: Icon(icon, color: accent),
          ),
          const SizedBox(height: PantriBoxSpacing.lg),
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: PantriBoxSpacing.xs),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: context.pantriBoxTheme.textSecondary,
            ),
          ),
          const SizedBox(height: PantriBoxSpacing.lg),
          action,
        ],
      ),
    );
  }
}
