import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../shared/data/models/category.dart';
import '../../../../shared/data/models/transaction.dart';
import '../../../../shared/data/models/wallet.dart';
import '../../../../shared/data/providers/isar.dart';
import '../../../../shared/enums/category_type.dart';
import '../../../../shared/enums/transaction_range_filter.dart';
import '../../../../shared/presentation/providers/selected_date_range_filter.dart';
import '../../../../shared/presentation/providers/selected_wallet.dart';
import '../../domain/entities/chart_detail_data.dart';
import 'selected_chart_detail_date.dart';

final chartDetailDataProvider = FutureProvider<ChartDetailData?>((ref) async {
  final isar = ref.watch(isarProvider).instance;
  final walletId = ref.watch(selectedWalletProvider).value?.id;
  final dateRangeFilter = ref.watch(selectedDateRangeFilterProvider);
  final date = ref.watch(selectedChartDetailDateProvider);

  if (date != null && walletId != null) {
    final nextDate = switch (dateRangeFilter) {
      DateRangeFilter.yearly => DateTime(
          date.year + 1,
        ),
      DateRangeFilter.monthly => DateTime(
          date.year,
          date.month + 1,
        ),
      DateRangeFilter.daily => DateTime(
          date.year,
          date.month,
          date.day + 1,
        ),
    };

    // await Future.delayed(const Duration(seconds: 2));

    return ChartDetailData(
      dateTime: date,
      transactions: await isar.transactionModels
          .filter()
          .wallet((q) => q.idEqualTo(walletId))
          .dateBetween(
            date,
            nextDate,
            includeLower: true,
            includeUpper: false,
          )
          .sortByDateDesc()
          .findAll(),
      totalIncome: await isar.transactionModels
          .filter()
          .wallet((q) => q.idEqualTo(walletId))
          .dateBetween(
            date,
            nextDate,
            includeLower: true,
            includeUpper: false,
          )
          .category((q) => q.typeEqualTo(CategoryType.income))
          .amountProperty()
          .sum(),
      totalExpense: await isar.transactionModels
          .filter()
          .wallet((q) => q.idEqualTo(walletId))
          .dateBetween(
            date,
            nextDate,
            includeLower: true,
            includeUpper: false,
          )
          .category((q) => q.typeEqualTo(CategoryType.expense))
          .amountProperty()
          .sum(),
    );
  }

  return null;
});
