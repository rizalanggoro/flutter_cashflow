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

  FutureUseCase<List<CategoryModel>> call({
    int? walletId,
    required CategoryType categoryType,
  }) async {
    try {
      if (walletId == null) {
        throw Failure(message: 'Tidak ada dompet dipilih!');
      }

      final categories = await _isar.categoryModels
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
          .findAll();

      return Right(categories);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(Failure(message: e.toString()));
    }
  }
}

// provider
final readCategoriesUseCaseProvider = Provider<_UseCase>((ref) {
  return _UseCase(isar: ref.watch(isarSourceProvider).instance);
});
