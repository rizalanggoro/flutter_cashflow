import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/utils/typedefs.dart';
import '../../../../data/sources/isar.dart';
import '../../../../shared/data/models/transaction.dart';

class _UseCase {
  final Isar _isar;

  _UseCase({required Isar isar}) : _isar = isar;

  FutureUseCase<TransactionModel> call({
    required int? transactionId,
  }) async {
    print('read transaction called');

    try {
      if (transactionId == null) {
        throw Failure(message: 'Id transaksi null');
      }

      final transaction = await _isar.transactionModels
          .filter()
          .idEqualTo(transactionId)
          .findFirst();
      if (transaction == null) {
        throw Failure(message: 'Transaksi tidak ditemukan!');
      }

      return Right(transaction);
    } catch (e) {
      return Left(
        e is Failure ? e : Failure(message: e.toString()),
      );
    }
  }
}

// provider
final readTransactionUseCaseProvider = Provider<_UseCase>((ref) {
  return _UseCase(isar: ref.watch(isarSourceProvider).instance);
});
