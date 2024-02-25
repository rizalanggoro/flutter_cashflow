import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/enums/transaction_range_filter.dart';
import '../../../providers/selected_date_range_filter.dart';

class SelectedTransactionDate {
  final DateTime yearly, monthly, daily;

  SelectedTransactionDate({
    required this.yearly,
    required this.monthly,
    required this.daily,
  });

  SelectedTransactionDate copyWith({
    DateTime? yearly,
    DateTime? monthly,
    DateTime? daily,
  }) =>
      SelectedTransactionDate(
        yearly: yearly ?? this.yearly,
        monthly: monthly ?? this.monthly,
        daily: daily ?? this.daily,
      );
}

class SelectedTransactionDateNotifier
    extends Notifier<SelectedTransactionDate> {
  @override
  SelectedTransactionDate build() {
    final currentDate = DateTime.now();
    return SelectedTransactionDate(
      yearly: DateTime(
        currentDate.year,
      ),
      monthly: DateTime(
        currentDate.year,
        currentDate.month,
      ),
      daily: DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
      ),
    );
  }

  void next() => _change(true);
  void previous() => _change(false);

  void _change(bool isAdd) {
    final dateRange = ref.read(selectedDateRangeFilterProvider);
    switch (dateRange) {
      case DateRangeFilter.yearly:
        state = state.copyWith(
          yearly: DateTime(
            state.yearly.year + (1 * (isAdd ? 1 : -1)),
          ),
        );
      case DateRangeFilter.monthly:
        state = state.copyWith(
          monthly: DateTime(
            state.monthly.year,
            state.monthly.month + (1 * (isAdd ? 1 : -1)),
          ),
        );
      case DateRangeFilter.daily:
        state = state.copyWith(
          daily: DateTime(
            state.daily.year,
            state.daily.month,
            state.daily.day + (1 * (isAdd ? 1 : -1)),
          ),
        );
    }
  }
}

final selectedTransactionDateProvider =
    NotifierProvider<SelectedTransactionDateNotifier, SelectedTransactionDate>(
        SelectedTransactionDateNotifier.new);
