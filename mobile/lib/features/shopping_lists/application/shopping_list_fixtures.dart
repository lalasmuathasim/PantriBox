import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pantribox_mobile/features/shopping_lists/application/shopping_list_summary.dart';

final shoppingListsProvider = Provider<List<ShoppingListSummary>>((ref) {
  return const [
    ShoppingListSummary(
      id: 'weekly-basics',
      name: 'Weekly basics',
      itemCount: 8,
      storeCount: 2,
      savingsLabel: '₹430 potential savings',
    ),
    ShoppingListSummary(
      id: 'quick-top-up',
      name: 'Quick top-up',
      itemCount: 4,
      storeCount: 1,
      savingsLabel: 'Awaiting live pricing data',
    ),
  ];
});
