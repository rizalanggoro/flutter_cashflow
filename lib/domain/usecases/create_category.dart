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

  FutureUseCase<CategoryModel> call({
    required String categoryName,
    required CategoryType categoryType,
    required WalletModel? wallet,
  }) async {
    try {
      // validation
      if (categoryName.trim().isEmpty) {
        throw Failure(message: 'Nama kategori tidak boleh kosong!');
      }

      if (wallet == null) {
        throw Failure(message: 'Tidak ada dompet yang dipilih!');
      }

      // check name availability
      final isAvailable = await _isar.categoryModels
          .filter()
          .wallet((q) => q.idEqualTo(wallet.id))
          .and()
          .nameEqualTo(categoryName, caseSensitive: false)
          .and()
          .typeEqualTo(categoryType)
          .isEmpty();
      if (!isAvailable) {
        throw Failure(
          message: 'Anda sudah memiliki kategori dengan nama dan tipe ini!',
        );
      }

      final currentDate = DateTime.now();
      final category = CategoryModel()
        ..name = categoryName
        ..type = categoryType
        ..wallet.value = wallet
        ..createdAt = currentDate
        ..updatedAt = currentDate;

      final resultId = await _isar.writeTxn(() async {
        final id = await _isar.categoryModels.put(category);
        await category.wallet.save();
        return id;
      });

      return Right(category..id = resultId);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(Failure(message: e.toString()));
    }
  }
}

// provider
final createCategoryUseCaseProvider = Provider<_UseCase>((ref) {
  return _UseCase(isar: ref.watch(isarSourceProvider).instance);
});
