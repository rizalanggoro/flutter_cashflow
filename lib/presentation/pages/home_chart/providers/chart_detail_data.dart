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
import '../models/chart_detail_data.dart';
import 'selected_chart_detail_date.dart';

class ChartDetailDataNotifier extends AsyncNotifier<ChartDetailData?> {
  @override
  Future<ChartDetailData?> build() async {
    final walletId = ref.watch(selectedWalletProvider).value?.id;
    final dateRangeFilter = ref.watch(selectedDateRangeFilterProvider);
    final currentDate = ref.watch(selectedChartDetailDateProvider);

    if (currentDate != null && walletId != null) {
      // init stream
      _initStreamSubscription(
        walletId: walletId,
        dateRangeFilter: dateRangeFilter,
        currentDate: currentDate,
      );

      return _read(
        walletId: walletId,
        dateRangeFilter: dateRangeFilter,
        currentDate: currentDate,
      );
    }

    return null;
  }

  void _initStreamSubscription({
    required int walletId,
    required DateRangeFilter dateRangeFilter,
    required DateTime currentDate,
  }) {
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

    final StreamSubscription subscription = ref
        .watch(isarSourceProvider)
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
        .watchLazy()
        .listen((event) async {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(
        () => _read(
          walletId: walletId,
          dateRangeFilter: dateRangeFilter,
          currentDate: currentDate,
        ),
      );
    });

    ref.onDispose(() => subscription.cancel());
  }

  Future<ChartDetailData> _read({
    required int walletId,
    required DateRangeFilter dateRangeFilter,
    required DateTime currentDate,
  }) async {
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

    return ChartDetailData(
      dateTime: currentDate,
      transactions: await ref
          .watch(isarSourceProvider)
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
          .sortByDateDesc()
          .findAll(),
      totalIncome: await ref
          .watch(isarSourceProvider)
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
          .watch(isarSourceProvider)
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
    );
  }
}

final chartDetailDataProvider =
    AsyncNotifierProvider<ChartDetailDataNotifier, ChartDetailData?>(
  ChartDetailDataNotifier.new,
);
