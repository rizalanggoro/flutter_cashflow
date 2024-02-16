import 'package:cashflow/features/home_chart/presentation/providers/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../shared/data/models/category.dart';
import '../../../../shared/data/models/transaction.dart';
import '../../../../shared/data/models/wallet.dart';
import '../../../../shared/data/sources/isar.dart';
import '../../../../shared/enums/category_type.dart';
import '../../../../shared/enums/transaction_range_filter.dart';
import '../../../../shared/presentation/providers/selected_date_range_filter.dart';
import '../../../../shared/presentation/providers/selected_wallet.dart';
import '../../domain/entities/chart_data_item.dart';

class ChartDataNotifier extends AsyncNotifier<List<ChartDataItem>> {
  @override
  Future<List<ChartDataItem>> build() async {
    final walletId = ref.watch(selectedWalletProvider).value?.id;
    if (walletId != null) {
      final dateRangeFilter = ref.watch(selectedDateRangeFilterProvider);
      final firstDate = ref.watch(selectedFirstChartDateProvider);

      // read data
      return _read(
        walletId: walletId,
        dateRangeFilter: dateRangeFilter,
        firstDate: firstDate,
      );

      // subscribe to stream
    }

    return [];
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
