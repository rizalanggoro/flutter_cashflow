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
    required WalletModel? wallet,
    required DateTime dateTime,
  }) async {
    try {
      if (wallet == null) {
        throw Failure(message: 'Tidak ada dompet dipilih!');
      }

      // reset date time: year only
      dateTime = DateTime(
        dateTime.year,
      );

      final startDate = DateTime(
        dateTime.year - 2,
      );

      final List<TransactionsChartItem> result = [];
      for (var a = 0; a < 3; a++) {
        final currentDate = DateTime(
          startDate.year + a,
        );
        final nextDate = DateTime(
          currentDate.year + 1,
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
final readYearlyTransactionsChartProvider = Provider<_UseCase>((ref) {
  return _UseCase(isar: ref.watch(isarProvider).instance);
});
