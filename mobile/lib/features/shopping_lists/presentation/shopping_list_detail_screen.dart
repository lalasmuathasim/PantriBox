import 'package:flutter/material.dart';
import 'package:pantribox_mobile/app/theme/pantribox_spacing.dart';
import 'package:pantribox_mobile/features/shopping_lists/application/shopping_plan_preview.dart';
import 'package:pantribox_mobile/shared/extensions/pantribox_theme_extension.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_card.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_metric_card.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_primary_button.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_section_header.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_status_chip.dart';

class ShoppingListDetailScreen extends StatelessWidget {
  const ShoppingListDetailScreen({required this.listId, super.key});

  final String listId;

  @override
  Widget build(BuildContext context) {
    final palette = context.pantriBoxTheme;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(PantriBoxSpacing.lg),
          children: [
            Text(
              'Weekly basics',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: PantriBoxSpacing.sm),
            Text(
              'List ID: $listId · Prepared for structured recommendation output once pricing and routing services are active.',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: palette.textSecondary),
            ),
            const SizedBox(height: PantriBoxSpacing.xl),
            const PantriBoxSectionHeader(
              title: 'Optimization-ready layout',
              subtitle:
                  'Prepared for structured plan output once the pricing and routing services exist.',
            ),
            const SizedBox(height: PantriBoxSpacing.sm),
            PantriBoxMetricCard(
              title: shoppingPlanPreview.title,
              value: shoppingPlanPreview.total,
              subtitle: shoppingPlanPreview.summary,
              footnote: shoppingPlanPreview.savings,
              badgeLabel: 'Best current split',
              badgeTone: PantriBoxStatusTone.primary,
              icon: Icons.savings_outlined,
              emphasis: true,
              footer: Wrap(
                spacing: PantriBoxSpacing.sm,
                runSpacing: PantriBoxSpacing.sm,
                children: const [
                  PantriBoxStatusChip(
                    label: '2 stores',
                    tone: PantriBoxStatusTone.info,
                  ),
                  PantriBoxStatusChip(
                    label: 'Freshness-aware',
                    tone: PantriBoxStatusTone.neutral,
                  ),
                  PantriBoxStatusChip(
                    label: 'Receipt-backed prices',
                    tone: PantriBoxStatusTone.success,
                  ),
                ],
              ),
            ),
            const SizedBox(height: PantriBoxSpacing.xl),
            ...shoppingPlanPreview.stores.map(
              (store) => Padding(
                padding: const EdgeInsets.only(bottom: PantriBoxSpacing.md),
                child: PantriBoxCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              store.name,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                          PantriBoxStatusChip(
                            label: store.distance,
                            tone: PantriBoxStatusTone.neutral,
                            icon: Icons.place_outlined,
                          ),
                        ],
                      ),
                      const SizedBox(height: PantriBoxSpacing.md),
                      Wrap(
                        spacing: PantriBoxSpacing.sm,
                        runSpacing: PantriBoxSpacing.sm,
                        children: store.items
                            .map(
                              (item) => PantriBoxStatusChip(
                                label: item,
                                tone: PantriBoxStatusTone.info,
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: PantriBoxSpacing.lg),
                      Row(
                        children: [
                          Text(
                            store.total,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 132,
                            child: PantriBoxPrimaryButton(
                              label: 'View route',
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: PantriBoxSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Compare alternatives'),
                  ),
                ),
                const SizedBox(width: PantriBoxSpacing.md),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Change preferences'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
