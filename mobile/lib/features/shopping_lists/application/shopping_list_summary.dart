class ShoppingListSummary {
  const ShoppingListSummary({
    required this.id,
    required this.name,
    required this.itemCount,
    required this.storeCount,
    required this.savingsLabel,
  });

  final String id;
  final String name;
  final int itemCount;
  final int storeCount;
  final String savingsLabel;
}
