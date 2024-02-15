import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../enums/transaction_range_filter.dart';

final selectedDateRangeFilterProvider = StateProvider<DateRangeFilter>((ref) {
  return DateRangeFilter.daily;
});
