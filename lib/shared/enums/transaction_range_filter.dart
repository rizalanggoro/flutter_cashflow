enum TransactionRangeFilter {
  yearly,
  monthly,
  daily,
}

extension XTransactionRangeFilter on TransactionRangeFilter {
  bool get isYearly => this == TransactionRangeFilter.yearly;
  bool get isMonthly => this == TransactionRangeFilter.monthly;
  bool get isDaily => this == TransactionRangeFilter.daily;
}
