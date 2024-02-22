import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/utils/typedefs.dart';
import '../../../../shared/data/models/transaction.dart';
import '../../../../shared/data/sources/isar.dart';

class _UseCase {
  final Isar _isar;

  _UseCase({required Isar isar}) : _isar = isar;

  UseCase<Stream<void>> call({
    required int transactionId,
  }) {
    try {
      final stream =
          _isar.transactionModels.where().idEqualTo(transactionId).watchLazy();
      return Right(stream);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}

// provider
final watchTransactionUseCaseProvider = Provider<_UseCase>((ref) {
  return _UseCase(isar: ref.watch(isarSourceProvider).instance);
});
