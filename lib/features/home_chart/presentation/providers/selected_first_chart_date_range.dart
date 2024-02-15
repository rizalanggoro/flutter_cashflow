import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/enums/transaction_range_filter.dart';
import '../../../../shared/presentation/providers/selected_date_range_filter.dart';
import 'selected_chart_date_range.dart';

final selectedFirstChartDateRangeProvider = Provider<DateTime>((ref) {
  final currentDate = ref.watch(selectedChartDateRangeProvider);

  switch (ref.watch(selectedDateRangeFilterProvider)) {
    case DateRangeFilter.yearly:
      return DateTime(
        currentDate.year - 2,
      );
    case DateRangeFilter.monthly:
      return DateTime(
        currentDate.year,
        currentDate.month - 3,
      );
    case DateRangeFilter.daily:
      return DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day - currentDate.weekday + 1,
      );
  }
});
