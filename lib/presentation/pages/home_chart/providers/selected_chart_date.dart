import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/enums/transaction_range_filter.dart';
import '../../../providers/selected_date_range_filter.dart';
import 'selected_chart_detail_date.dart';

class SelectedChartDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final dateRangeFilter = ref.watch(selectedDateRangeFilterProvider);

    final currentDate = DateTime.now();
    return switch (dateRangeFilter) {
      DateRangeFilter.yearly => DateTime(
          currentDate.year,
        ),
      DateRangeFilter.monthly => DateTime(
          currentDate.year,
          currentDate.month,
        ),
      DateRangeFilter.daily => DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
        ),
    };
  }

  void next() => _changeDate(true);
  void previous() => _changeDate(false);

  void _changeDate(bool isAdd) {
    switch (ref.read(selectedDateRangeFilterProvider)) {
      case DateRangeFilter.yearly:
        state = DateTime(
          state.year + (3 * (isAdd ? 1 : -1)),
        );
      case DateRangeFilter.monthly:
        state = DateTime(
          state.year,
          state.month + (4 * (isAdd ? 1 : -1)),
        );
      case DateRangeFilter.daily:
        state = DateTime(
          state.year,
          state.month,
          state.day + (7 * (isAdd ? 1 : -1)),
        );
    }

    // reset detail
    ref.read(selectedChartDetailDateProvider.notifier).reset();
  }
}

final selectedChartDateProvider =
    NotifierProvider<SelectedChartDateNotifier, DateTime>(
  SelectedChartDateNotifier.new,
);
