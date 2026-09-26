class ShoppingPlanPreview {
  const ShoppingPlanPreview({
    required this.title,
    required this.total,
    required this.summary,
    required this.savings,
    required this.stores,
  });

  final String title;
  final String total;
  final String summary;
  final String savings;
  final List<StorePlanPreview> stores;
}

class StorePlanPreview {
  const StorePlanPreview({
    required this.name,
    required this.distance,
    required this.items,
    required this.total,
  });

  final String name;
  final String distance;
  final List<String> items;
  final String total;
}

const shoppingPlanPreview = ShoppingPlanPreview(
  title: 'Best shopping plan',
  total: '₹1,820',
  summary: '8 items · 2 stores · 5.2 km',
  savings: 'You save ₹430 compared with the latest known split.',
  stores: [
    StorePlanPreview(
      name: 'DMart',
      distance: '2.1 km',
      items: ['Milk', 'Rice', 'Eggs', 'Detergent'],
      total: '₹1,240',
    ),
    StorePlanPreview(
      name: 'Local Fresh Market',
      distance: '1.4 km',
      items: ['Chicken', 'Tomatoes', 'Onions'],
      total: '₹580',
    ),
  ],
);
