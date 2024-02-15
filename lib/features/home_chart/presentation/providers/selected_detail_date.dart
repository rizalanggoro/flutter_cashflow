import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/enums/transaction_range_filter.dart';
import '../../../../shared/presentation/providers/selected_date_range_filter.dart';

class SelectedDetailDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    return switch (ref.watch(selectedDateRangeFilterProvider)) {
      DateRangeFilter.yearly => DateTime(
          DateTime.now().year,
        ),
      DateRangeFilter.monthly => DateTime(
          DateTime.now().year,
          DateTime.now().month,
        ),
      DateRangeFilter.daily => DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        ),
    };
  }

  void next() => _changeDate(true);
  void prev() => _changeDate(false);

  void _changeDate(bool isAdd) {
    switch (ref.read(selectedDateRangeFilterProvider)) {
      case DateRangeFilter.yearly:
        state = DateTime(
          state.year + (isAdd ? 1 : -1),
        );
      case DateRangeFilter.monthly:
        state = DateTime(
          state.year,
          state.month + (isAdd ? 1 : -1),
        );
      case DateRangeFilter.daily:
        state = DateTime(
          state.year,
          state.month,
          state.day + (isAdd ? 1 : -1),
        );
    }
  }
}

final selectedDetailDateProvider =
    NotifierProvider<SelectedDetailDateNotifier, DateTime>(
  SelectedDetailDateNotifier.new,
);
