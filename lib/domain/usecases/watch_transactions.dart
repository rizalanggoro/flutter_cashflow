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

  UseCase<Stream<void>> call({int? walletId}) {
    try {
      if (walletId == null) {
        throw Failure(message: 'Tidak ada dompet dipilih!');
      }

      return Right(_isar.transactionModels
          .filter()
          .category((q) => q.wallet((q) => q.idEqualTo(walletId)))
          .watchLazy());
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(Failure(message: e.toString()));
    }
  }
}

// provider
final watchTransactionsUseCaseProvider = Provider<_UseCase>((ref) {
  return _UseCase(isar: ref.watch(isarSourceProvider).instance);
});
