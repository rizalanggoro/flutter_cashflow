import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/enums/transaction_range_filter.dart';
import '../../../providers/selected_date_range_filter.dart';
import 'selected_chart_date.dart';

final selectedLastChartDateProvider = Provider<DateTime>((ref) {
  final currentDate = ref.watch(selectedChartDateProvider);

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
