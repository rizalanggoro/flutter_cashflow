import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/utils/typedefs.dart';
import '../../../../data/sources/isar.dart';
import '../../../../shared/data/models/category.dart';
import '../../../../shared/data/models/transaction.dart';

class _UseCase {
  final Isar _isar;

  _UseCase({required Isar isar}) : _isar = isar;

  FutureUseCase<bool> call({
    required int categoryId,
  }) async {
    try {
      final result = await _isar.writeTxn(
        () async {
          // delete transactions
          await _isar.transactionModels
              .filter()
              .category((q) => q.idEqualTo(categoryId))
              .deleteAll();

          // delete category
          final id = await _isar.categoryModels.delete(categoryId);

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
final deleteCategoryUseCaseProvider = Provider<_UseCase>((ref) {
  return _UseCase(isar: ref.watch(isarSourceProvider).instance);
});
