class HomeOverview {
  const HomeOverview({
    required this.greeting,
    this.userName,
    this.monthlySpendLabel,
    this.estimatedSavingsLabel,
    this.activeListName,
    this.activeListItemCount,
    this.completedListItemCount,
    this.recentPurchases = const [],
  });

  final String greeting;
  final String? userName;
  final String? monthlySpendLabel;
  final String? estimatedSavingsLabel;
  final String? activeListName;
  final int? activeListItemCount;
  final int? completedListItemCount;
  final List<RecentPurchasePreview> recentPurchases;

  bool get hasActiveShoppingList =>
      activeListName != null && activeListItemCount != null;

  bool get hasHouseholdSummary =>
      monthlySpendLabel != null || estimatedSavingsLabel != null;
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
