import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../core/failure/failure.dart';
import '../../core/utils/typedefs.dart';
import '../../data/models/category.dart';
import '../../data/models/transaction.dart';
import '../../data/sources/isar.dart';

class _UseCase {
  final Isar _isar;

  _UseCase({required Isar isar}) : _isar = isar;

  FutureUseCase<int> call({
    required TransactionModel? oldTransaction,
    required double amount,
    required String note,
    CategoryModel? category,
    required DateTime dateTime,
  }) async {
    try {
      if (oldTransaction == null) {
        throw Failure(message: 'Transaksi sebelumnya null!');
      }

      if (amount <= 0) {
        throw Failure(message: 'Nominal transaksi tidak valid!');
      }

      if (category == null) {
        throw Failure(message: 'Tidak ada kategori dipilih!');
      }

      final currentDate = DateTime.now();
      final transaction = TransactionModel()
        ..id = oldTransaction.id
        ..wallet.value = oldTransaction.wallet.value
        ..createdAt = oldTransaction.createdAt
        ..amount = amount
        ..note = note
        ..category.value = category
        ..date = dateTime
        ..updatedAt = currentDate;

      final result = await _isar.writeTxn(
        () async {
          final id = await _isar.transactionModels.put(transaction);
          await transaction.category.save();
          await transaction.wallet.save();
          return id;
        },
      );

      return Right(result);
    } catch (e) {
      return Left(
        e is Failure ? e : Failure(message: e.toString()),
      );
    }
  }
}

// provider
final updateTransactionUseCaseProvider = Provider<_UseCase>((ref) {
  return _UseCase(isar: ref.watch(isarSourceProvider).instance);
});
