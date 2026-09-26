import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pantribox_mobile/app/theme/pantribox_spacing.dart';
import 'package:pantribox_mobile/features/shopping_lists/application/shopping_list_fixtures.dart';
import 'package:pantribox_mobile/shared/extensions/pantribox_theme_extension.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_card.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_primary_button.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_screen_header.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_section_header.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_status_chip.dart';

class ShoppingListsScreen extends ConsumerWidget {
  const ShoppingListsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lists = ref.watch(shoppingListsProvider);
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
            eyebrow: 'Plan your next trip',
            title: 'Shopping lists',
            subtitle: 'Structured items now, optimization-ready plans later.',
            trailing: IconButton.filledTonal(
              onPressed: () => context.go('/lists/create'),
              icon: const Icon(Icons.add_rounded),
              tooltip: 'Create shopping list',
            ),
          ),
          const SizedBox(height: PantriBoxSpacing.xl),
          const PantriBoxCard(
            child: Row(
              children: [
                Expanded(
                  child: _ListSummaryMetric(
                    title: 'Active lists',
                    value: '2',
                    caption: 'Current fixture set',
                  ),
                ),
                SizedBox(width: PantriBoxSpacing.md),
                Expanded(
                  child: _ListSummaryMetric(
                    title: 'Potential savings',
                    value: '₹430',
                    caption: 'Latest plan preview',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: PantriBoxSpacing.xl),
          const PantriBoxSectionHeader(
            title: 'Structured by design',
            subtitle:
                'Optimization results will be stored as data, not generated paragraphs.',
          ),
          const SizedBox(height: PantriBoxSpacing.lg),
          ...lists.map(
            (list) => Padding(
              padding: const EdgeInsets.only(bottom: PantriBoxSpacing.md),
              child: PantriBoxCard(
                onTap: () => context.go('/lists/${list.id}'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            list.name,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        const PantriBoxStatusChip(
                          label: 'Optimization ready',
                          tone: PantriBoxStatusTone.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: PantriBoxSpacing.sm),
                    Text(
                      '${list.itemCount} items · up to ${list.storeCount} stores',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                    const SizedBox(height: PantriBoxSpacing.md),
                    Text(
                      list.savingsLabel,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: PantriBoxSpacing.lg),
                    PantriBoxPrimaryButton(
                      label: 'Open list',
                      icon: Icons.arrow_forward_rounded,
                      onPressed: () => context.go('/lists/${list.id}'),
                    ),
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

class _ListSummaryMetric extends StatelessWidget {
  const _ListSummaryMetric({
    required this.title,
    required this.value,
    required this.caption,
  });

  final String title;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final palette = context.pantriBoxTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: palette.textSecondary),
        ),
        const SizedBox(height: PantriBoxSpacing.xs),
        Text(value, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: PantriBoxSpacing.xs),
        Text(
          caption,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: palette.textMuted),
        ),
      ],
    );
  }
}
