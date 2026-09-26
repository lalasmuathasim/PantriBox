import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pantribox_mobile/app/theme/pantribox_spacing.dart';
import 'package:pantribox_mobile/features/home/application/home_demo_fixtures.dart';
import 'package:pantribox_mobile/shared/extensions/pantribox_theme_extension.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_card.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_list_tile.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_metric_card.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_primary_button.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_quick_action.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_screen_header.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_section_header.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_status_chip.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overview = ref.watch(homeOverviewProvider);
    final theme = Theme.of(context);
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
          PantriBoxScreenHeader(
            eyebrow: overview.greetingEyebrow,
            title: overview.greeting,
            subtitle: overview.householdLabel,
            trailing: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: palette.surface,
                shape: BoxShape.circle,
                boxShadow: palette.cardShadow,
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                color: palette.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: PantriBoxSpacing.lg),
          PantriBoxMetricCard(
            title: 'Monthly grocery spending',
            value: overview.monthlySpendLabel,
            subtitle: 'Updated from recent household purchases',
            badgeLabel: 'On track',
            badgeTone: PantriBoxStatusTone.primary,
            icon: Icons.shopping_bag_outlined,
            emphasis: true,
            footer: Wrap(
              spacing: PantriBoxSpacing.sm,
              runSpacing: PantriBoxSpacing.sm,
              children: [
                PantriBoxStatusChip(
                  label: '${overview.estimatedSavingsLabel} potential savings',
                  tone: PantriBoxStatusTone.success,
                  icon: Icons.savings_outlined,
                ),
                const PantriBoxStatusChip(
                  label: '8 items active',
                  tone: PantriBoxStatusTone.info,
                  icon: Icons.playlist_add_check_circle_outlined,
                ),
                const PantriBoxStatusChip(
                  label: 'Receipt-first intelligence',
                  tone: PantriBoxStatusTone.neutral,
                ),
              ],
            ),
          ),
          const SizedBox(height: PantriBoxSpacing.xl),
          Row(
            children: [
              Expanded(
                child: _MiniMetricCard(
                  title: 'Estimated savings',
                  value: overview.estimatedSavingsLabel,
                  icon: Icons.trending_down_rounded,
                ),
              ),
              const SizedBox(width: PantriBoxSpacing.md),
              Expanded(
                child: _MiniMetricCard(
                  title: 'Active list',
                  value: '${overview.activeListItemCount} items',
                  icon: Icons.checklist_rtl_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: PantriBoxSpacing.xl),
          const PantriBoxSectionHeader(
            title: 'Quick actions',
            subtitle: 'The key entry points for the initial product journey.',
          ),
          const SizedBox(height: PantriBoxSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                PantriBoxQuickAction(
                  label: 'Create list',
                  subtitle: 'Start a new grocery run',
                  icon: Icons.playlist_add_rounded,
                  onTap: () => context.go('/lists/create'),
                ),
                const SizedBox(width: PantriBoxSpacing.md),
                PantriBoxQuickAction(
                  label: 'Scan receipt',
                  subtitle: 'Capture price evidence',
                  icon: Icons.document_scanner_outlined,
                  onTap: () => context.go('/scan'),
                ),
                const SizedBox(width: PantriBoxSpacing.md),
                PantriBoxQuickAction(
                  label: 'Compare prices',
                  subtitle: 'Preview the best plan',
                  icon: Icons.local_offer_outlined,
                  onTap: () => context.go('/lists/weekly-basics'),
                ),
              ],
            ),
          ),
          const SizedBox(height: PantriBoxSpacing.xl),
          PantriBoxSectionHeader(
            title: 'Active shopping list',
            subtitle:
                'Current structured list ready for future comparison and optimization.',
            trailing: TextButton(
              onPressed: () => context.go('/lists/weekly-basics'),
              child: const Text('Open'),
            ),
          ),
          const SizedBox(height: PantriBoxSpacing.sm),
          PantriBoxCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        overview.activeListName,
                        style: theme.textTheme.headlineMedium,
                      ),
                    ),
                    const PantriBoxStatusChip(
                      label: 'Ready to compare',
                      tone: PantriBoxStatusTone.primary,
                    ),
                  ],
                ),
                const SizedBox(height: PantriBoxSpacing.sm),
                Text(
                  '${overview.activeListItemCount} items waiting for pricing, store, and routing preferences.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
                const SizedBox(height: PantriBoxSpacing.lg),
                PantriBoxPrimaryButton(
                  label: 'Find best prices',
                  icon: Icons.auto_awesome_outlined,
                  onPressed: () => context.go('/lists/weekly-basics'),
                ),
              ],
            ),
          ),
          const SizedBox(height: PantriBoxSpacing.xl),
          const PantriBoxSectionHeader(
            title: 'Recent purchases',
            subtitle:
                'Representative fixture data kept outside the widget tree.',
          ),
          const SizedBox(height: PantriBoxSpacing.sm),
          ...overview.recentPurchases.map(
            (purchase) => Padding(
              padding: const EdgeInsets.only(bottom: PantriBoxSpacing.md),
              child: PantriBoxListTile(
                title: purchase.store,
                subtitle: purchase.summary,
                caption: purchase.timeLabel,
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: palette.primarySoft,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.receipt_long_outlined,
                    color: palette.primary,
                  ),
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(purchase.amount, style: theme.textTheme.titleMedium),
                    const SizedBox(height: PantriBoxSpacing.xs),
                    const Icon(Icons.chevron_right_rounded),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniMetricCard extends StatelessWidget {
  const _MiniMetricCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final palette = context.pantriBoxTheme;

    return PantriBoxCard(
      padding: const EdgeInsets.all(PantriBoxSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: palette.primarySoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: palette.primary, size: 18),
          ),
          const SizedBox(height: PantriBoxSpacing.md),
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: PantriBoxSpacing.xs),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}
