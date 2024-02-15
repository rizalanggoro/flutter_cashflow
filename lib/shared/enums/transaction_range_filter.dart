enum DateRangeFilter {
  yearly,
  monthly,
  daily,
}

extension XDateRangeFilter on DateRangeFilter {
  bool get isYearly => this == DateRangeFilter.yearly;
  bool get isMonthly => this == DateRangeFilter.monthly;
  bool get isDaily => this == DateRangeFilter.daily;
}
