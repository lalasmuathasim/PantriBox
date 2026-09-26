enum ProductLookupState { found, notFound, incomplete, stale }

class ProductNutrition {
  const ProductNutrition({
    required this.energyKcal100g,
    required this.proteinG100g,
    required this.carbohydrateG100g,
    required this.totalSugarG100g,
    required this.addedSugarG100g,
    required this.fatG100g,
    required this.saturatedFatG100g,
    required this.transFatG100g,
    required this.fiberG100g,
    required this.sodiumMg100g,
  });

  factory ProductNutrition.fromJson(Map<String, dynamic> json) {
    return ProductNutrition(
      energyKcal100g: _asDouble(json['energy_kcal_100g']),
      proteinG100g: _asDouble(json['protein_g_100g']),
      carbohydrateG100g: _asDouble(json['carbohydrate_g_100g']),
      totalSugarG100g: _asDouble(json['total_sugar_g_100g']),
      addedSugarG100g: _asDouble(json['added_sugar_g_100g']),
      fatG100g: _asDouble(json['fat_g_100g']),
      saturatedFatG100g: _asDouble(json['saturated_fat_g_100g']),
      transFatG100g: _asDouble(json['trans_fat_g_100g']),
      fiberG100g: _asDouble(json['fiber_g_100g']),
      sodiumMg100g: _asDouble(json['sodium_mg_100g']),
    );
  }

  final double? energyKcal100g;
  final double? proteinG100g;
  final double? carbohydrateG100g;
  final double? totalSugarG100g;
  final double? addedSugarG100g;
  final double? fatG100g;
  final double? saturatedFatG100g;
  final double? transFatG100g;
  final double? fiberG100g;
  final double? sodiumMg100g;
}

class ProductIngredient {
  const ProductIngredient({required this.rawText, this.canonicalName});

  factory ProductIngredient.fromJson(Map<String, dynamic> json) {
    return ProductIngredient(
      rawText: json['raw_text'] as String? ?? '',
      canonicalName: json['canonical_name'] as String?,
    );
  }

  final String rawText;
  final String? canonicalName;
}

class ProductLookupResult {
  const ProductLookupResult({
    required this.barcode,
    required this.state,
    required this.productName,
    required this.brand,
    required this.packageQuantity,
    required this.packageUnit,
    required this.source,
    required this.retrievedAt,
    required this.nutrition,
    required this.ingredients,
    required this.isCached,
  });

  factory ProductLookupResult.fromJson(Map<String, dynamic> json) {
    final rawNutrition = json['nutrition'];
    final rawIngredients = json['ingredients'];
    return ProductLookupResult(
      barcode: json['barcode'] as String,
      state: _stateFrom(json['state'] as String?),
      productName: json['product_name'] as String?,
      brand: json['brand'] as String?,
      packageQuantity: _asDouble(json['package_quantity']),
      packageUnit: json['package_unit'] as String?,
      source: json['source'] as String?,
      retrievedAt: DateTime.tryParse(json['retrieved_at'] as String? ?? ''),
      nutrition: rawNutrition is Map<String, dynamic>
          ? ProductNutrition.fromJson(rawNutrition)
          : null,
      ingredients: rawIngredients is List<dynamic>
          ? rawIngredients
                .whereType<Map<String, dynamic>>()
                .map(ProductIngredient.fromJson)
                .toList(growable: false)
          : const [],
      isCached: json['is_cached'] as bool? ?? false,
    );
  }

  final String barcode;
  final ProductLookupState state;
  final String? productName;
  final String? brand;
  final double? packageQuantity;
  final String? packageUnit;
  final String? source;
  final DateTime? retrievedAt;
  final ProductNutrition? nutrition;
  final List<ProductIngredient> ingredients;
  final bool isCached;

  bool get isProductAvailable => productName != null;
}

double? _asDouble(Object? value) {
  if (value is num) {
    return value.toDouble();
  }
  return null;
}

ProductLookupState _stateFrom(String? value) {
  return switch (value) {
    'found' => ProductLookupState.found,
    'incomplete' => ProductLookupState.incomplete,
    'stale' => ProductLookupState.stale,
    _ => ProductLookupState.notFound,
  };
}
