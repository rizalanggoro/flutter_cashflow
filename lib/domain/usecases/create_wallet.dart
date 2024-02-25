import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../core/constants/default_categories.dart';
import '../../core/enums/category_type.dart';
import '../../core/failure/failure.dart';
import '../../core/utils/typedefs.dart';
import '../../data/models/category.dart';
import '../../data/models/transaction.dart';
import '../../data/models/wallet.dart';
import '../../data/sources/isar.dart';

class _UseCase {
  final Isar _isar;

  _UseCase({required Isar isar}) : _isar = isar;

  FutureUseCase<WalletModel> call({
    required String walletName,
    required bool addInitialCategories,
    required double initialAmount,
  }) async {
    try {
      if (walletName.trim().isEmpty) {
        throw Failure(message: 'Nama dompet tidak boleh kosong!');
      }

      final currentDate = DateTime.now();
      final wallet = WalletModel()
        ..name = walletName
        ..createdAt = currentDate
        ..updatedAt = currentDate;

      final resultId = await _isar.writeTxn(
        () => _isar.walletModels.put(wallet),
      );
      wallet.id = resultId;

      // add initial categories
      if (addInitialCategories) {
        // - incomes
        await _isar.writeTxn(() async {
          final categories = DefaultCategories.incomes.map(
            (e) => CategoryModel()
              ..name = e
              ..type = CategoryType.income
              ..createdAt = currentDate
              ..updatedAt = currentDate
              ..wallet.value = wallet,
          );

          for (var a = 0; a < categories.length; a++) {
            final item = categories.elementAt(a);
            final resultId = await _isar.categoryModels.put(item);
            await item.wallet.save();

            // initial amount
            if (initialAmount > 0 && a == categories.length - 1) {
              // other income category
              final transaction = TransactionModel()
                ..amount = initialAmount
                ..note = 'Saldo awal'
                ..wallet.value = wallet
                ..category.value = (item..id = resultId)
                ..date = currentDate
                ..createdAt = currentDate
                ..updatedAt = currentDate;

              // save initial amount transaction
              await _isar.transactionModels.put(transaction);
              await transaction.wallet.save();
              await transaction.category.save();
            }
          }
        });

        // - expense
        await _isar.writeTxn(() async {
          final categories =
              DefaultCategories.expenses.map((e) => CategoryModel()
                ..name = e
                ..type = CategoryType.expense
                ..createdAt = currentDate
                ..updatedAt = currentDate
                ..wallet.value = wallet);

          for (final item in categories) {
            await _isar.categoryModels.put(item);
            await item.wallet.save();
          }
        });
      }

      return Right(wallet);
    } catch (e) {
      return Left(
        e is Failure ? e : Failure(message: e.toString()),
      );
    }
  }
}

// provider
final createWalletUseCaseProvider = Provider<_UseCase>((ref) {
  return _UseCase(isar: ref.watch(isarSourceProvider).instance);
});
