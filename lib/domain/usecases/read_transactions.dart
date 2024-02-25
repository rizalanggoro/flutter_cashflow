import 'package:cashflow/core/enums/transaction_range_filter.dart';
import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../core/failure/failure.dart';
import '../../core/utils/typedefs.dart';
import '../../data/models/category.dart';
import '../../data/models/transaction.dart';
import '../../data/models/wallet.dart';
import '../../data/sources/isar.dart';

class _UseCase {
  final Isar _isar;

  _UseCase({required Isar isar}) : _isar = isar;

  FutureUseCase<List<TransactionModel>> call({
    int? walletId,
    required DateRangeFilter rangeFilter,
    required DateTime dateTime,
  }) async {
    try {
      if (walletId == null) {
        throw Failure(message: 'Tidak ada dompet dipilih!');
      }

      final transactions = await _isar.transactionModels
          .filter()
          .category((q) => q.wallet((q) => q.idEqualTo(walletId)))
          .optional(
            rangeFilter.isYearly,
            (q) => q.dateBetween(
              DateTime(dateTime.year),
              DateTime(dateTime.year + 1),
              includeLower: true,
              includeUpper: false,
            ),
          )
          .optional(
            rangeFilter.isMonthly,
            (q) => q.dateBetween(
              DateTime(dateTime.year, dateTime.month),
              DateTime(dateTime.year, dateTime.month + 1),
              includeLower: true,
              includeUpper: false,
            ),
          )
          .optional(
            rangeFilter.isDaily,
            (q) => q.dateBetween(
              DateTime(dateTime.year, dateTime.month, dateTime.day),
              DateTime(dateTime.year, dateTime.month, dateTime.day + 1),
              includeLower: true,
              includeUpper: false,
            ),
          )
          .sortByDateDesc()
          .findAll();

      return Right(transactions);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(Failure(message: e.toString()));
    }
  }
}

// provider
final readTransactionsUseCaseProvider = Provider<_UseCase>((ref) {
  return _UseCase(isar: ref.watch(isarSourceProvider).instance);
});
