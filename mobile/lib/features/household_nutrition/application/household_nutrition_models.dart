class HouseholdNutritionInsight {
  const HouseholdNutritionInsight({
    required this.periodStart,
    required this.periodEnd,
    required this.methodologyReadiness,
    required this.methodologyDisclaimer,
    required this.completeness,
    required this.nutrientTotals,
  });

  factory HouseholdNutritionInsight.fromJson(Map<String, dynamic> json) {
    final methodology =
        json['methodology'] as Map<String, dynamic>? ?? const {};
    final rawCompleteness =
        json['completeness'] as Map<String, dynamic>? ?? const {};
    final rawTotals = json['nutrient_totals'] as List<dynamic>? ?? const [];
    return HouseholdNutritionInsight(
      periodStart: DateTime.parse(json['period_start'] as String),
      periodEnd: DateTime.parse(json['period_end'] as String),
      methodologyReadiness:
          methodology['readiness'] as String? ?? 'not_approved',
      methodologyDisclaimer: methodology['disclaimer'] as String? ?? '',
      completeness: NutritionDataCompleteness.fromJson(rawCompleteness),
      nutrientTotals: rawTotals
          .whereType<Map<String, dynamic>>()
          .map(NutrientPurchaseTotal.fromJson)
          .toList(growable: false),
    );
  }

  final DateTime periodStart;
  final DateTime periodEnd;
  final String methodologyReadiness;
  final String methodologyDisclaimer;
  final NutritionDataCompleteness completeness;
  final List<NutrientPurchaseTotal> nutrientTotals;
}

class NutritionDataCompleteness {
  const NutritionDataCompleteness({
    required this.totalPurchaseItems,
    required this.identifiedProducts,
    required this.itemsWithNutritionData,
    required this.itemsWithUsableQuantity,
  });

  factory NutritionDataCompleteness.fromJson(Map<String, dynamic> json) {
    int read(String key) => (json[key] as num?)?.toInt() ?? 0;
    return NutritionDataCompleteness(
      totalPurchaseItems: read('total_purchase_items'),
      identifiedProducts: read('identified_products'),
      itemsWithNutritionData: read('items_with_nutrition_data'),
      itemsWithUsableQuantity: read('items_with_usable_quantity'),
    );
  }

  final int totalPurchaseItems;
  final int identifiedProducts;
  final int itemsWithNutritionData;
  final int itemsWithUsableQuantity;
}

class NutrientPurchaseTotal {
  const NutrientPurchaseTotal({
    required this.nutrient,
    required this.unit,
    required this.value,
    required this.contributingItemCount,
  });

  factory NutrientPurchaseTotal.fromJson(Map<String, dynamic> json) {
    return NutrientPurchaseTotal(
      nutrient: json['nutrient'] as String? ?? '',
      unit: json['unit'] as String? ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0,
      contributingItemCount:
          (json['contributing_item_count'] as num?)?.toInt() ?? 0,
    );
  }

  final String nutrient;
  final String unit;
  final double value;
  final int contributingItemCount;
}

class HouseholdMember {
  const HouseholdMember({
    required this.id,
    required this.displayName,
    required this.dateOfBirth,
    required this.sex,
    required this.isActive,
  });

  factory HouseholdMember.fromJson(Map<String, dynamic> json) {
    return HouseholdMember(
      id: json['id'] as String,
      displayName: json['display_name'] as String? ?? '',
      dateOfBirth: DateTime.tryParse(json['date_of_birth'] as String? ?? ''),
      sex: json['sex'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  final String id;
  final String displayName;
  final DateTime? dateOfBirth;
  final String? sex;
  final bool isActive;
}
