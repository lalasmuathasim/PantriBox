import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pantribox_mobile/app/theme/pantribox_spacing.dart';
import 'package:pantribox_mobile/features/insights/application/insight_fixtures.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_card.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_empty_state.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_primary_button.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_screen_header.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_section_header.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            eyebrow: 'Future household intelligence',
            title: 'Insights',
            subtitle:
                'This screen will later combine spending, savings, price trends, and shopping frequency.',
          ),
          const SizedBox(height: PantriBoxSpacing.xl),
          PantriBoxCard(
            child: PantriBoxEmptyState(
              title: 'Household nutrition insights',
              message:
                  'See how identified grocery purchases can build a nutrition-coverage view without making intake or medical claims.',
              icon: Icons.eco_outlined,
              action: PantriBoxPrimaryButton(
                label: 'View nutrition insights',
                icon: Icons.arrow_forward_rounded,
                onPressed: () => context.push('/insights/nutrition'),
              ),
            ),
          ),
          const SizedBox(height: PantriBoxSpacing.xl),
          const PantriBoxSectionHeader(
            title: 'Preview containers',
            subtitle:
                'Representative mock panels reserved for future analytics.',
          ),
          const SizedBox(height: PantriBoxSpacing.md),
          ...insightMetrics.map(
            (metric) => Padding(
              padding: const EdgeInsets.only(bottom: PantriBoxSpacing.md),
              child: PantriBoxCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      metric.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: PantriBoxSpacing.sm),
                    Text(
                      metric.value,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: PantriBoxSpacing.xs),
                    Text(
                      metric.caption,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: PantriBoxSpacing.xl),
          const PantriBoxCard(
            child: PantriBoxEmptyState(
              title: 'Insight panels come later',
              message:
                  'This screen intentionally reserves space for spending trends, price history, and household purchase intelligence once those specs become active.',
            ),
          ),
        ],
      ),
    );
  }
}
