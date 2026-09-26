import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pantribox_mobile/features/home/application/home_overview.dart';

final homeOverviewProvider = Provider<HomeOverview>((ref) {
  return const HomeOverview(
    greeting: 'Good evening',
    monthlySpendLabel: '₹18,240',
    estimatedSavingsLabel: '₹1,420',
    activeListName: 'Weekend stock-up',
    activeListItemCount: 8,
    completedListItemCount: 3,
    recentPurchases: [
      RecentPurchasePreview(
        store: 'DMart',
        summary: 'Milk, eggs, rice and pantry staples',
        amount: '₹1,240',
        timeLabel: 'Today · Receipt confirmed',
      ),
      RecentPurchasePreview(
        store: 'Fresh Market',
        summary: 'Tomatoes, onions and chicken',
        amount: '₹580',
        timeLabel: 'Yesterday · Manual review complete',
      ),
      RecentPurchasePreview(
        store: 'Quick Shop',
        summary: 'Detergent refill and extras',
        amount: '₹310',
        timeLabel: '3 days ago · Price observation saved',
      ),
    ],
  );
});
