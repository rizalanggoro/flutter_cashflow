import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/utils/typedefs.dart';
import '../../../../shared/data/models/category.dart';
import '../../../../shared/data/models/transaction.dart';
import '../../../../shared/data/models/wallet.dart';
import '../../../../shared/data/sources/isar.dart';

class _DeleteWalletUseCase {
  final Isar _isar;

  _DeleteWalletUseCase({
    required Isar isar,
  }) : _isar = isar;

  FutureUseCase<bool> call({
    required int id,
  }) async {
    try {
      final result = await _isar.writeTxn(() async {
        // delete transactions
        await _isar.transactionModels
            .filter()
            .wallet((q) => q.idEqualTo(id))
            .deleteAll();

        // delete categories
        await _isar.categoryModels
            .filter()
            .wallet((q) => q.idEqualTo(id))
            .deleteAll();

        // delete wallet
        return _isar.walletModels.delete(id);
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
final deleteWalletUseCaseProvider = Provider<_DeleteWalletUseCase>((ref) {
  return _DeleteWalletUseCase(isar: ref.watch(isarSourceProvider).instance);
});
