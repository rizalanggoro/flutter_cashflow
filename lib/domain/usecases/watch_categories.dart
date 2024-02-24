import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../core/enums/category_type.dart';
import '../../core/failure/failure.dart';
import '../../core/utils/typedefs.dart';
import '../../data/models/category.dart';
import '../../data/models/wallet.dart';
import '../../data/sources/isar.dart';

class _UseCase {
  final Isar _isar;

  _UseCase({required Isar isar}) : _isar = isar;

  UseCase<Stream<void>> call({
    int? walletId,
    required CategoryType categoryType,
  }) {
    try {
      if (walletId == null) {
        throw Failure(message: 'Tidak ada dompet dipilih!');
      }

      return Right(
        _isar.categoryModels
            .filter()
            .wallet((q) => q.idEqualTo(walletId))
            .optional(
              categoryType.isIncome,
              (q) => q.typeEqualTo(CategoryType.income),
            )
            .optional(
              categoryType.isExpense,
              (q) => q.typeEqualTo(CategoryType.expense),
            )
            .watchLazy(),
      );
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(Failure(message: e.toString()));
    }
  }
}

// provider
final watchCategoriesUseCaseProvider = Provider<_UseCase>((ref) {
  return _UseCase(isar: ref.watch(isarSourceProvider).instance);
});
