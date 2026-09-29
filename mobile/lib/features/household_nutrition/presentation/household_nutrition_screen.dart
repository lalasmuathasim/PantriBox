import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pantribox_mobile/app/theme/pantribox_spacing.dart';
import 'package:pantribox_mobile/features/household_nutrition/application/household_nutrition_models.dart';
import 'package:pantribox_mobile/features/household_nutrition/application/household_nutrition_repository.dart';
import 'package:pantribox_mobile/shared/extensions/pantribox_theme_extension.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_card.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_empty_state.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_loading_state.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_page_app_bar.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_screen_header.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_section_header.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_status_chip.dart';

class HouseholdNutritionScreen extends ConsumerWidget {
  const HouseholdNutritionScreen({super.key, this.householdId});

  final String? householdId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final householdId = this.householdId;
    return Scaffold(
      appBar: const PantriBoxPageAppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            PantriBoxSpacing.lg,
            PantriBoxSpacing.md,
            PantriBoxSpacing.lg,
            PantriBoxSpacing.xxl,
          ),
          children: [
            const PantriBoxScreenHeader(
              eyebrow: 'Household grocery coverage',
              title: 'Nutrition insights',
              subtitle:
                  'Based on identified grocery purchases, not individual food intake.',
            ),
            const SizedBox(height: PantriBoxSpacing.xl),
            if (householdId == null)
              const _HouseholdContextRequired()
            else
              _InsightBody(householdId: householdId),
          ],
        ),
      ),
    );
  }
}

class _InsightBody extends ConsumerWidget {
  const _InsightBody({required this.householdId});

  final String householdId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now();
    final insight = ref.watch(
      householdNutritionInsightProvider(
        _NutritionRequest(
          householdId: householdId,
          periodStart: DateTime(today.year, today.month, 1),
          periodEnd: today,
        ),
      ),
    );
    return insight.when(
      loading: () => const PantriBoxCard(child: PantriBoxLoadingState()),
      error: (error, stackTrace) => PantriBoxCard(
        child: PantriBoxEmptyState(
          title: 'Nutrition insights are unavailable',
          message:
              'We could not load household purchase coverage right now. Your grocery data has not been changed.',
          icon: Icons.cloud_off_outlined,
        ),
      ),
      data: (data) => _InsightData(insight: data),
    );
  }
}

final householdNutritionInsightProvider = FutureProvider.autoDispose
    .family<HouseholdNutritionInsight, _NutritionRequest>((ref, request) {
      return ref
          .watch(householdNutritionRepositoryProvider)
          .fetchInsight(
            householdId: request.householdId,
            periodStart: request.periodStart,
            periodEnd: request.periodEnd,
          );
    });

class _NutritionRequest {
  const _NutritionRequest({
    required this.householdId,
    required this.periodStart,
    required this.periodEnd,
  });

  final String householdId;
  final DateTime periodStart;
  final DateTime periodEnd;

  @override
  bool operator ==(Object other) {
    return other is _NutritionRequest &&
        other.householdId == householdId &&
        other.periodStart == periodStart &&
        other.periodEnd == periodEnd;
  }

  @override
  int get hashCode => Object.hash(householdId, periodStart, periodEnd);
}

class _InsightData extends StatelessWidget {
  const _InsightData({required this.insight});

  final HouseholdNutritionInsight insight;

  @override
  Widget build(BuildContext context) {
    if (insight.completeness.totalPurchaseItems == 0) {
      return const PantriBoxCard(
        child: PantriBoxEmptyState(
          title: 'No purchase history for this period',
          message:
              'Nutrition coverage will become available after grocery purchases are recorded and products are identified.',
          icon: Icons.receipt_long_outlined,
        ),
      );
    }

    final palette = context.pantriBoxTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PantriBoxCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('This month', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: PantriBoxSpacing.sm),
              Text(
                '${insight.completeness.identifiedProducts} of ${insight.completeness.totalPurchaseItems} purchase items identified',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: PantriBoxSpacing.sm),
              Text(
                '${insight.completeness.itemsWithNutritionData} have declared nutrition data · ${insight.completeness.itemsWithUsableQuantity} have usable quantities',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: palette.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: PantriBoxSpacing.xl),
        const PantriBoxSectionHeader(
          title: 'Available purchase totals',
          subtitle:
              'These are observed grocery-purchase totals, not dietary targets or intake.',
        ),
        const SizedBox(height: PantriBoxSpacing.sm),
        if (insight.nutrientTotals.isEmpty)
          const PantriBoxCard(
            child: PantriBoxEmptyState(
              title: 'Nutrition information is incomplete',
              message:
                  'Identified products need source-backed nutrition data and a supported quantity before totals can be shown.',
              icon: Icons.data_usage_outlined,
            ),
          )
        else
          ...insight.nutrientTotals.map(
            (total) => Padding(
              padding: const EdgeInsets.only(bottom: PantriBoxSpacing.sm),
              child: PantriBoxCard(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _labelFor(total.nutrient),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Text(
                      '${total.value.toStringAsFixed(total.value.truncateToDouble() == total.value ? 0 : 1)} ${total.unit}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ),
          ),
        const SizedBox(height: PantriBoxSpacing.lg),
        PantriBoxCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PantriBoxStatusChip(
                label: 'Reference methodology pending approval',
                tone: PantriBoxStatusTone.warning,
              ),
              const SizedBox(height: PantriBoxSpacing.sm),
              Text(
                insight.methodologyDisclaimer,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: PantriBoxSpacing.sm),
              Text(
                'Food recommendations will be available only after an approved methodology and food-nutrient dataset are configured.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: palette.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HouseholdContextRequired extends StatelessWidget {
  const _HouseholdContextRequired();

  @override
  Widget build(BuildContext context) {
    return const PantriBoxCard(
      child: PantriBoxEmptyState(
        title: 'Set up your household first',
        message:
            'Nutrition insights will connect to the signed-in household once account and purchase-history workflows are active.',
        icon: Icons.groups_outlined,
      ),
    );
  }
}

String _labelFor(String nutrient) => switch (nutrient) {
  'energy_kcal' => 'Energy',
  'protein' => 'Protein',
  'carbohydrate' => 'Carbohydrate',
  'fibre' => 'Fibre',
  'sodium' => 'Sodium',
  _ => nutrient,
};
