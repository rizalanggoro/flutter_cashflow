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

  _UseCase({
    required Isar isar,
  }) : _isar = isar;

  FutureUseCase<bool> call({
    required int walletId,
  }) async {
    try {
      final result = await _isar.writeTxn(() async {
        // delete transactions
        await _isar.transactionModels
            .filter()
            .wallet((q) => q.idEqualTo(walletId))
            .deleteAll();

        // delete categories
        await _isar.categoryModels
            .filter()
            .wallet((q) => q.idEqualTo(walletId))
            .deleteAll();

        // delete wallet
        return _isar.walletModels.delete(walletId);
      });

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
final deleteWalletByIdUseCaseProvider = Provider<_UseCase>((ref) {
  return _UseCase(isar: ref.watch(isarSourceProvider).instance);
});
