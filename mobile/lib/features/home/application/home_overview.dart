class HomeOverview {
  const HomeOverview({
    required this.greetingEyebrow,
    required this.greeting,
    required this.householdLabel,
    required this.monthlySpendLabel,
    required this.estimatedSavingsLabel,
    required this.activeListName,
    required this.activeListItemCount,
    required this.recentPurchases,
  });

  final String greetingEyebrow;
  final String greeting;
  final String householdLabel;
  final String monthlySpendLabel;
  final String estimatedSavingsLabel;
  final String activeListName;
  final int activeListItemCount;
  final List<RecentPurchasePreview> recentPurchases;
}

class RecentPurchasePreview {
  const RecentPurchasePreview({
    required this.store,
    required this.summary,
    required this.amount,
    required this.timeLabel,
  });

  final String store;
  final String summary;
  final String amount;
  final String timeLabel;
}
