import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pantribox_mobile/app/theme/pantribox_spacing.dart';
import 'package:pantribox_mobile/features/product_intelligence/application/product_intelligence_repository.dart';
import 'package:pantribox_mobile/features/product_intelligence/application/product_lookup_models.dart';
import 'package:pantribox_mobile/shared/extensions/pantribox_theme_extension.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_card.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_empty_state.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_loading_state.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_primary_button.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_screen_header.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_section_header.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_status_chip.dart';

class ProductLookupScreen extends ConsumerStatefulWidget {
  const ProductLookupScreen({super.key});

  @override
  ConsumerState<ProductLookupScreen> createState() =>
      _ProductLookupScreenState();
}

class _ProductLookupScreenState extends ConsumerState<ProductLookupScreen> {
  final _barcodeController = TextEditingController();
  ProductLookupResult? _result;
  String? _error;
  bool _isLoading = false;

  @override
  void dispose() {
    _barcodeController.dispose();
    super.dispose();
  }

  Future<void> _lookupProduct() async {
    final barcode = _barcodeController.text.trim();
    if (barcode.isEmpty) {
      setState(() => _error = 'Enter the barcode printed on the package.');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
    });
    try {
      final result = await ref
          .read(productIntelligenceRepositoryProvider)
          .lookupBarcode(barcode);
      if (mounted) {
        setState(() => _result = result);
      }
    } on ProductLookupException catch (error) {
      if (mounted) {
        setState(() => _error = error.message);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
              eyebrow: 'Product intelligence',
              title: 'Look up a packaged food',
              subtitle:
                  'Enter its barcode to see available nutrition and ingredient information.',
            ),
            const SizedBox(height: PantriBoxSpacing.xl),
            PantriBoxCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _barcodeController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _lookupProduct(),
                    decoration: const InputDecoration(
                      labelText: 'Product barcode',
                      hintText: 'For example, 8901234567890',
                      prefixIcon: Icon(Icons.qr_code_rounded),
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: PantriBoxSpacing.sm),
                    Text(
                      _error!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: context.pantriBoxTheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: PantriBoxSpacing.lg),
                  PantriBoxPrimaryButton(
                    label: 'Look up product',
                    icon: Icons.search_rounded,
                    onPressed: _isLoading ? null : _lookupProduct,
                  ),
                ],
              ),
            ),
            const SizedBox(height: PantriBoxSpacing.xl),
            if (_isLoading) const PantriBoxCard(child: PantriBoxLoadingState()),
            if (_result != null) _ProductReport(result: _result!),
          ],
        ),
      ),
    );
  }
}

class _ProductReport extends StatelessWidget {
  const _ProductReport({required this.result});

  final ProductLookupResult result;

  @override
  Widget build(BuildContext context) {
    if (!result.isProductAvailable) {
      return PantriBoxCard(
        child: PantriBoxEmptyState(
          title: 'Product not found yet',
          message:
              'Try a label scan when that workflow is available, or check the barcode and try again.',
          icon: Icons.search_off_rounded,
        ),
      );
    }

    final palette = context.pantriBoxTheme;
    final packageLabel = _packageLabel(result);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PantriBoxCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result.productName!,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              if (result.brand != null) ...[
                const SizedBox(height: PantriBoxSpacing.xs),
                Text(
                  result.brand!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: palette.textSecondary),
                ),
              ],
              if (packageLabel != null) ...[
                const SizedBox(height: PantriBoxSpacing.xs),
                Text(
                  packageLabel,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: PantriBoxSpacing.md),
              Wrap(
                spacing: PantriBoxSpacing.xs,
                runSpacing: PantriBoxSpacing.xs,
                children: [
                  if (result.source != null)
                    PantriBoxStatusChip(
                      label: 'Source: ${_sourceLabel(result.source!)}',
                      tone: PantriBoxStatusTone.info,
                    ),
                  if (result.isCached)
                    const PantriBoxStatusChip(
                      label: 'Cached result',
                      tone: PantriBoxStatusTone.neutral,
                    ),
                  if (result.state == ProductLookupState.stale)
                    const PantriBoxStatusChip(
                      label: 'May be outdated',
                      tone: PantriBoxStatusTone.warning,
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: PantriBoxSpacing.xl),
        const PantriBoxSectionHeader(
          title: 'Nutrition',
          subtitle: 'Available values per 100 g. Missing values are not shown.',
        ),
        const SizedBox(height: PantriBoxSpacing.sm),
        PantriBoxCard(child: _NutritionSummary(nutrition: result.nutrition)),
        const SizedBox(height: PantriBoxSpacing.xl),
        const PantriBoxSectionHeader(
          title: 'Ingredients',
          subtitle: 'Provided by the current product-data source.',
        ),
        const SizedBox(height: PantriBoxSpacing.sm),
        PantriBoxCard(child: _IngredientList(ingredients: result.ingredients)),
      ],
    );
  }
}

class _NutritionSummary extends StatelessWidget {
  const _NutritionSummary({required this.nutrition});

  final ProductNutrition? nutrition;

  @override
  Widget build(BuildContext context) {
    final facts = nutrition;
    if (facts == null) {
      return const Text(
        'Nutrition information is not available for this product.',
      );
    }
    final values = <(String, String)>[
      if (facts.energyKcal100g != null)
        ('Energy', '${facts.energyKcal100g!.round()} kcal'),
      if (facts.proteinG100g != null) ('Protein', '${facts.proteinG100g} g'),
      if (facts.totalSugarG100g != null)
        ('Total sugar', '${facts.totalSugarG100g} g'),
      if (facts.addedSugarG100g != null)
        ('Added sugar', '${facts.addedSugarG100g} g'),
      if (facts.fiberG100g != null) ('Fiber', '${facts.fiberG100g} g'),
      if (facts.sodiumMg100g != null)
        ('Sodium', '${facts.sodiumMg100g!.round()} mg'),
    ];
    if (values.isEmpty) {
      return const Text(
        'Nutrition information is not available for this product.',
      );
    }
    return Column(
      children: values
          .map(
            (value) => Padding(
              padding: const EdgeInsets.symmetric(
                vertical: PantriBoxSpacing.xs,
              ),
              child: Row(
                children: [
                  Expanded(child: Text(value.$1)),
                  Text(
                    value.$2,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _IngredientList extends StatelessWidget {
  const _IngredientList({required this.ingredients});

  final List<ProductIngredient> ingredients;

  @override
  Widget build(BuildContext context) {
    if (ingredients.isEmpty) {
      return const Text(
        'Ingredient information is not available for this product.',
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ingredients
          .map(
            (ingredient) => Padding(
              padding: const EdgeInsets.only(bottom: PantriBoxSpacing.xs),
              child: Text('- ${ingredient.rawText}'),
            ),
          )
          .toList(growable: false),
    );
  }
}

String? _packageLabel(ProductLookupResult result) {
  if (result.packageQuantity == null || result.packageUnit == null) {
    return null;
  }
  final quantity = result.packageQuantity!;
  final value = quantity == quantity.roundToDouble()
      ? quantity.toInt().toString()
      : quantity.toString();
  return '$value ${result.packageUnit} package';
}

String _sourceLabel(String source) {
  return switch (source) {
    'open_food_facts' => 'Open Food Facts',
    _ => source,
  };
}
