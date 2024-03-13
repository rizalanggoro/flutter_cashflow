import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../core/enums/category_type.dart';
import '../../../../core/enums/transaction_range_filter.dart';
import '../../../../data/models/category.dart';
import '../../../../data/models/transaction.dart';
import '../../../../data/models/wallet.dart';
import '../../../../data/sources/isar.dart';
import '../../../providers/selected_date_range_filter.dart';
import '../../../providers/selected_wallet.dart';
import '../models/chart_data_item.dart';
import 'providers.dart';

class ChartDataNotifier extends AsyncNotifier<List<ChartDataItem>> {
  @override
  Future<List<ChartDataItem>> build() async {
    final walletId = ref.watch(selectedWalletProvider).value?.id;
    if (walletId != null) {
      final dateRangeFilter = ref.watch(selectedDateRangeFilterProvider);

      final firstDate = ref.watch(selectedFirstChartDateProvider);
      final lastDate = ref.watch(selectedLastChartDateProvider);

      // subscribe to stream
      _initStreamSubscription(
        walletId: walletId,
        dateRangeFilter: dateRangeFilter,
        firstDate: firstDate,
        lastDate: lastDate,
      );

      // read data
      return _read(
        walletId: walletId,
        dateRangeFilter: dateRangeFilter,
        firstDate: firstDate,
      );
    }

    return [];
  }

  void _initStreamSubscription({
    required int walletId,
    required DateRangeFilter dateRangeFilter,
    required DateTime firstDate,
    required DateTime lastDate,
  }) {
    final nextLastDate = switch (dateRangeFilter) {
      DateRangeFilter.yearly => DateTime(
          lastDate.year + 1,
        ),
      DateRangeFilter.monthly => DateTime(
          lastDate.year,
          lastDate.month + 1,
        ),
      DateRangeFilter.daily => DateTime(
          lastDate.year,
          lastDate.month,
          lastDate.day + 1,
        ),
    };

    StreamSubscription subscription = ref
        .read(isarSourceProvider)
        .instance
        .transactionModels
        .filter()
        .wallet((q) => q.idEqualTo(walletId))
        .dateBetween(
          firstDate,
          nextLastDate,
          includeLower: true,
          includeUpper: false,
        )
        .watchLazy()
        .listen((event) async {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(
        () => _read(
          walletId: walletId,
          dateRangeFilter: dateRangeFilter,
          firstDate: firstDate,
        ),
      );
    });

    ref.onDispose(() => subscription.cancel());
  }

  Future<List<ChartDataItem>> _read({
    required int walletId,
    required DateRangeFilter dateRangeFilter,
    required DateTime firstDate,
  }) async {
    final List<ChartDataItem> result = [];

    final counts = {
      DateRangeFilter.yearly: 3,
      DateRangeFilter.monthly: 4,
      DateRangeFilter.daily: 7,
    };

    for (var a = 0; a < counts[dateRangeFilter]!; a++) {
      final currentDate = switch (dateRangeFilter) {
        DateRangeFilter.yearly => DateTime(
            firstDate.year + a,
          ),
        DateRangeFilter.monthly => DateTime(
            firstDate.year,
            firstDate.month + a,
          ),
        DateRangeFilter.daily => DateTime(
            firstDate.year,
            firstDate.month,
            firstDate.day + a,
          ),
      };

      final nextDate = switch (dateRangeFilter) {
        DateRangeFilter.yearly => DateTime(
            currentDate.year + 1,
          ),
        DateRangeFilter.monthly => DateTime(
            currentDate.year,
            currentDate.month + 1,
          ),
        DateRangeFilter.daily => DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day + 1,
          ),
      };

      result.add(ChartDataItem(
        totalIncome: await ref
            .read(isarSourceProvider)
            .instance
            .transactionModels
            .filter()
            .wallet((q) => q.idEqualTo(walletId))
            .dateBetween(
              currentDate,
              nextDate,
              includeLower: true,
              includeUpper: false,
            )
            .category((q) => q.typeEqualTo(CategoryType.income))
            .amountProperty()
            .sum(),
        totalExpense: await ref
            .read(isarSourceProvider)
            .instance
            .transactionModels
            .filter()
            .wallet((q) => q.idEqualTo(walletId))
            .dateBetween(
              currentDate,
              nextDate,
              includeLower: true,
              includeUpper: false,
            )
            .category((q) => q.typeEqualTo(CategoryType.expense))
            .amountProperty()
            .sum(),
        dateTime: currentDate,
      ));
    }

    return result;
  }
}

// provider
final chartDataProvider =
    AsyncNotifierProvider<ChartDataNotifier, List<ChartDataItem>>(
  ChartDataNotifier.new,
);
