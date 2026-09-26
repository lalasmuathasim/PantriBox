import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pantribox_mobile/app/theme/pantribox_radius.dart';
import 'package:pantribox_mobile/app/theme/pantribox_spacing.dart';
import 'package:pantribox_mobile/features/home/application/home_demo_fixtures.dart';
import 'package:pantribox_mobile/features/home/application/home_overview.dart';
import 'package:pantribox_mobile/shared/extensions/pantribox_theme_extension.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_card.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_empty_state.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_primary_button.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_screen_header.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_section_header.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_workflow_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overview = ref.watch(homeOverviewProvider);
    final palette = context.pantriBoxTheme;
    final greeting = overview.userName == null
        ? overview.greeting
        : '${overview.greeting}, ${overview.userName}';

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
            eyebrow: greeting,
            title: 'What would you like to do?',
            trailing: Semantics(
              button: true,
              label: 'Notifications',
              child: Container(
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
          ),
          const SizedBox(height: PantriBoxSpacing.lg),
          _PlanShoppingCard(overview: overview),
          const SizedBox(height: PantriBoxSpacing.md),
          const _SecondaryWorkflows(),
          const SizedBox(height: PantriBoxSpacing.xl),
          _HouseholdSummary(overview: overview),
          if (overview.recentPurchases.isNotEmpty) ...[
            const SizedBox(height: PantriBoxSpacing.xl),
            const PantriBoxSectionHeader(
              title: 'Recent activity',
              subtitle: 'A quick look at your latest shopping updates.',
            ),
            const SizedBox(height: PantriBoxSpacing.sm),
            ...overview.recentPurchases.map(
              (purchase) => Padding(
                padding: const EdgeInsets.only(bottom: PantriBoxSpacing.md),
                child: _RecentActivityCard(purchase: purchase),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RecentActivityCard extends StatelessWidget {
  const _RecentActivityCard({required this.purchase});

  final RecentPurchasePreview purchase;

  @override
  Widget build(BuildContext context) {
    final palette = context.pantriBoxTheme;

    return PantriBoxCard(
      padding: const EdgeInsets.all(PantriBoxSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: palette.primarySoft,
                  borderRadius: BorderRadius.circular(PantriBoxRadius.sm),
                ),
                child: Icon(
                  Icons.receipt_long_outlined,
                  color: palette.primary,
                ),
              ),
              const SizedBox(width: PantriBoxSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      purchase.store,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: PantriBoxSpacing.xs),
                    Text(
                      purchase.summary,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: PantriBoxSpacing.sm),
          Text(
            purchase.timeLabel,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: palette.textMuted),
          ),
          const SizedBox(height: PantriBoxSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              purchase.amount,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanShoppingCard extends StatelessWidget {
  const _PlanShoppingCard({required this.overview});

  final HomeOverview overview;

  @override
  Widget build(BuildContext context) {
    final isContinuing = overview.hasActiveShoppingList;
    final itemCount = overview.activeListItemCount;
    final completedItemCount = overview.completedListItemCount;
    final description = isContinuing
        ? '${overview.activeListName} · $itemCount items${completedItemCount == null ? '' : ' · $completedItemCount checked'}'
        : 'Create a list and find where to buy for less.';

    return PantriBoxWorkflowCard(
      title: isContinuing ? 'Continue shopping' : 'Plan your shopping',
      description: description,
      actionLabel: isContinuing ? 'Continue list' : 'Start a list',
      emphasis: PantriBoxWorkflowCardEmphasis.primary,
      visual: _WorkflowVisual(
        icon: Icons.shopping_basket_outlined,
        overlayIcon: Icons.checklist_rounded,
        accent: context.pantriBoxTheme.primary,
        size: 82,
      ),
      onTap: () =>
          context.push(isContinuing ? '/lists/weekly-basics' : '/lists/create'),
      footer: isContinuing
          ? Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => context.push('/lists/create'),
                child: const Text('Start a new list'),
              ),
            )
          : null,
    );
  }
}

class _SecondaryWorkflows extends StatelessWidget {
  const _SecondaryWorkflows();

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final receiptCard = PantriBoxWorkflowCard(
      title: 'Scan a receipt',
      description: 'Track what you bought and spent.',
      actionLabel: 'Scan receipt',
      visual: _WorkflowVisual(
        icon: Icons.receipt_long_outlined,
        overlayIcon: Icons.document_scanner_outlined,
        accent: context.pantriBoxTheme.info,
      ),
      onTap: () => context.push('/scan/receipt'),
    );
    final productCard = PantriBoxWorkflowCard(
      title: 'Check a product',
      description: 'Understand what\'s inside before you buy.',
      actionLabel: 'Check product',
      visual: _WorkflowVisual(
        icon: Icons.inventory_2_outlined,
        overlayIcon: Icons.qr_code_scanner_rounded,
        accent: context.pantriBoxTheme.primary,
      ),
      onTap: () => context.push('/scan/product'),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final shouldStack = constraints.maxWidth < 360 || textScale > 1.25;
        if (shouldStack) {
          return Column(
            key: const Key('home-secondary-workflows'),
            children: [
              receiptCard,
              const SizedBox(height: PantriBoxSpacing.md),
              productCard,
            ],
          );
        }

        return Row(
          key: const Key('home-secondary-workflows'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: receiptCard),
            const SizedBox(width: PantriBoxSpacing.md),
            Expanded(child: productCard),
          ],
        );
      },
    );
  }
}

class _HouseholdSummary extends StatelessWidget {
  const _HouseholdSummary({required this.overview});

  final HomeOverview overview;

  @override
  Widget build(BuildContext context) {
    if (!overview.hasHouseholdSummary) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PantriBoxSectionHeader(title: 'Your household insights'),
          const SizedBox(height: PantriBoxSpacing.sm),
          PantriBoxCard(
            child: PantriBoxEmptyState(
              title: 'Insights will build as you go',
              message:
                  'Your spending and savings will appear here as you use PantriBox.',
              icon: Icons.insights_outlined,
              action: PantriBoxPrimaryButton(
                label: 'Scan your first receipt',
                icon: Icons.document_scanner_outlined,
                onPressed: () => context.push('/scan/receipt'),
              ),
            ),
          ),
        ],
      );
    }

    final metrics = <Widget>[
      if (overview.monthlySpendLabel != null)
        _HouseholdMetricCard(
          title: 'This month',
          value: overview.monthlySpendLabel!,
          caption: 'spent',
          icon: Icons.shopping_bag_outlined,
        ),
      if (overview.estimatedSavingsLabel != null)
        _HouseholdMetricCard(
          title: 'Estimated savings',
          value: overview.estimatedSavingsLabel!,
          caption: 'saved',
          icon: Icons.savings_outlined,
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PantriBoxSectionHeader(
          title: 'Your household',
          trailing: TextButton(
            onPressed: () => context.go('/insights'),
            child: const Text('See insights'),
          ),
        ),
        const SizedBox(height: PantriBoxSpacing.sm),
        if (metrics.length == 1)
          metrics.single
        else
          Row(
            children: [
              Expanded(child: metrics.first),
              const SizedBox(width: PantriBoxSpacing.md),
              Expanded(child: metrics.last),
            ],
          ),
      ],
    );
  }
}

class _HouseholdMetricCard extends StatelessWidget {
  const _HouseholdMetricCard({
    required this.title,
    required this.value,
    required this.caption,
    required this.icon,
  });

  final String title;
  final String value;
  final String caption;
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
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: palette.primarySoft,
              borderRadius: BorderRadius.circular(PantriBoxRadius.sm),
            ),
            child: Icon(icon, color: palette.primary, size: 20),
          ),
          const SizedBox(height: PantriBoxSpacing.md),
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: PantriBoxSpacing.xs),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
          Text(
            caption,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: palette.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _WorkflowVisual extends StatelessWidget {
  const _WorkflowVisual({
    required this.icon,
    required this.overlayIcon,
    required this.accent,
    this.size = 60,
  });

  final IconData icon;
  final IconData overlayIcon;
  final Color accent;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size + 10,
      height: size + 10,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(PantriBoxRadius.xmd),
            ),
            child: Icon(icon, color: accent, size: size * 0.48),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.4,
              height: size * 0.4,
              decoration: BoxDecoration(
                color: context.pantriBoxTheme.surface,
                shape: BoxShape.circle,
                boxShadow: context.pantriBoxTheme.cardShadow,
              ),
              child: Icon(overlayIcon, color: accent, size: size * 0.2),
            ),
          ),
        ],
      ),
    );
  }
}
