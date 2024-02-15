import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/enums/transaction_range_filter.dart';
import '../../../../shared/presentation/providers/selected_date_range_filter.dart';

class SelectedChartDateRangeNotifier extends Notifier<DateTime> {
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
  }
}

final selectedChartDateRangeProvider =
    NotifierProvider<SelectedChartDateRangeNotifier, DateTime>(
  SelectedChartDateRangeNotifier.new,
);
