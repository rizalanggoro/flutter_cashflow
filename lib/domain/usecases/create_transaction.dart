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

  FutureUseCase<int> call({
    required double amount,
    required String note,
    required WalletModel? wallet,
    required CategoryModel? category,
    required DateTime dateTime,
  }) async {
    try {
      if (wallet == null) {
        throw Failure(message: 'Tidak ada dompet dipilih!');
      }

      if (amount <= 0) {
        throw Failure(message: 'Nominal transaksi tidak valid!');
      }

      final currentDate = DateTime.now();
      final transaction = TransactionModel()
        ..amount = amount
        ..note = note
        ..wallet.value = wallet
        ..category.value = category
        ..date = dateTime
        ..createdAt = currentDate
        ..updatedAt = currentDate;

      if (category == null) {
        throw Failure(message: 'Tidak ada kategori dipilih!');
      }

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
      if (e is Failure) {
        return Left(e);
      }
      return Left(Failure(message: e.toString()));
    }
  }
}

// provider
final createTransactionUseCaseProvider = Provider<_UseCase>((ref) {
  return _UseCase(isar: ref.watch(isarSourceProvider).instance);
});
