import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/enums/transaction_range_filter.dart';
import '../../../../shared/presentation/providers/selected_date_range_filter.dart';
import 'selected_date_range.dart';

final lastSelectedDateRangeProvider = Provider<DateTime>((ref) {
  final currentDate = ref.watch(selectedDateRangeProvider);

  switch (ref.watch(selectedDateRangeFilterProvider)) {
    case DateRangeFilter.yearly:
      return currentDate;
    case DateRangeFilter.monthly:
      return currentDate;
    case DateRangeFilter.daily:
      return DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day + (7 - currentDate.weekday),
      );
  }
});
