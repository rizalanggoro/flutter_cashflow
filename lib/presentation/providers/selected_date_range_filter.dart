import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/enums/transaction_range_filter.dart';

final selectedDateRangeFilterProvider = StateProvider<DateRangeFilter>((ref) {
  return DateRangeFilter.daily;
});
