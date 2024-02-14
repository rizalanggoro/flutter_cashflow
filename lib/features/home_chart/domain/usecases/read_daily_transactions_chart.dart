import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/utils/typedefs.dart';
import '../../../../shared/data/models/category.dart';
import '../../../../shared/data/models/transaction.dart';
import '../../../../shared/data/models/wallet.dart';
import '../../../../shared/data/providers/isar.dart';
import '../../../../shared/enums/category_type.dart';
import '../entities/transactions_chart_item.dart';

class _UseCase {
  final Isar _isar;

  _UseCase({required Isar isar}) : _isar = isar;

  FutureUseCase<List<TransactionsChartItem>> call({
    WalletModel? wallet,
    required DateTime dateTime,
  }) async {
    try {
      if (wallet == null) {
        throw Failure(message: 'Tidak ada dompet dipilih!');
      }

      // reset date time: year, month, day only
      dateTime = DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
      );

      final currentWeekday = dateTime.weekday;
      final startDate = dateTime.subtract(Duration(days: currentWeekday - 1));

      final List<TransactionsChartItem> result = [];
      for (var a = 0; a < 7; a++) {
        final currentDate = startDate.add(Duration(days: a));
        final nextDate = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day + 1,
        );

        result.add(TransactionsChartItem(
          totalIncome: await _isar.transactionModels
              .filter()
              .wallet((q) => q.idEqualTo(wallet.id))
              .dateBetween(
                currentDate,
                nextDate,
                includeLower: true,
                includeUpper: false,
              )
              .category((q) => q.typeEqualTo(CategoryType.income))
              .amountProperty()
              .sum(),
          totalExpense: await _isar.transactionModels
              .filter()
              .wallet((q) => q.idEqualTo(wallet.id))
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

      return Right(result);
    } catch (e) {
      return Left(
        e is Failure ? e : Failure(message: e.toString()),
      );
    }
  }
}

// provider
final readDailyTransactionsChartProvider = Provider<_UseCase>((ref) {
  return _UseCase(isar: ref.watch(isarProvider).instance);
});
