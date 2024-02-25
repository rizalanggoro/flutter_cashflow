import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/enums/transaction_range_filter.dart';
import '../../../providers/selected_date_range_filter.dart';
import 'providers.dart';

class SelectedChartDetailDateNotifier extends Notifier<DateTime?> {
  @override
  DateTime? build() {
    ref.watch(selectedDateRangeFilterProvider);
    return null;
  }

  void next() => _changeDate(true);
  void previous() => _changeDate(false);
  void change({required DateTime? dateTime}) =>
      state = state == dateTime ? null : dateTime;
  void reset() => state = null;

  void _changeDate(bool isAdd) {
    if (state != null) {
      final firstDate = ref.read(selectedFirstChartDateProvider);
      final lastDate = ref.read(selectedLastChartDateProvider);

      if ((!isAdd && firstDate == state) || (isAdd && lastDate == state)) {
        return;
      }

      switch (ref.read(selectedDateRangeFilterProvider)) {
        case DateRangeFilter.yearly:
          state = DateTime(
            state!.year + (isAdd ? 1 : -1),
          );
        case DateRangeFilter.monthly:
          state = DateTime(
            state!.year,
            state!.month + (isAdd ? 1 : -1),
          );
        case DateRangeFilter.daily:
          state = DateTime(
            state!.year,
            state!.month,
            state!.day + (isAdd ? 1 : -1),
          );
      }
    }
  }
}

final selectedChartDetailDateProvider =
    NotifierProvider<SelectedChartDetailDateNotifier, DateTime?>(
  SelectedChartDetailDateNotifier.new,
);
