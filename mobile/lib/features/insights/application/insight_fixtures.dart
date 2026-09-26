class InsightMetricPreview {
  const InsightMetricPreview({
    required this.title,
    required this.value,
    required this.caption,
  });

  final String title;
  final String value;
  final String caption;
}

const insightMetrics = <InsightMetricPreview>[
  InsightMetricPreview(
    title: 'Spending this month',
    value: '₹18,240',
    caption: 'Representative fixture until live analytics are specified.',
  ),
  InsightMetricPreview(
    title: 'Potential savings',
    value: '₹1,420',
    caption: 'Based on current comparison placeholder data.',
  ),
  InsightMetricPreview(
    title: 'Observed products',
    value: '126',
    caption:
        'Price history and trends will build from receipt-confirmed items.',
  ),
];
