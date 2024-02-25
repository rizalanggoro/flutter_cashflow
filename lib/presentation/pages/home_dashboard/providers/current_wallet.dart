import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../core/enums/category_type.dart';
import '../../../../core/failure/failure.dart';
import '../../../../data/models/category.dart';
import '../../../../data/models/transaction.dart';
import '../../../../data/models/wallet.dart';
import '../../../../data/sources/isar.dart';
import '../../../providers/selected_wallet.dart';
import '../models/current_wallet_data.dart';

class CurrentWalletNotifier extends AsyncNotifier<CurrentWalletData> {
  @override
  Future<CurrentWalletData> build() async {
    final walletId = ref.watch(selectedWalletProvider).value?.id;

    if (walletId == null) {
      throw Failure(message: 'Tidak ada dompet dipilih!');
    }

    final currentDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
    );
    final nextDate = DateTime(
      currentDate.year,
      currentDate.month + 1,
    );

    _listenStream(
      walletId: walletId,
      currentDate: currentDate,
      nextDate: nextDate,
    );

    return _read(
      walletId: walletId,
      currentDate: currentDate,
      nextDate: nextDate,
    );
  }

  Future<CurrentWalletData> _read({
    required int walletId,
    required DateTime currentDate,
    required DateTime nextDate,
  }) async {
    return CurrentWalletData(
      totalBalance: await ref
              .watch(isarSourceProvider)
              .instance
              .transactionModels
              .filter()
              .wallet((q) => q.idEqualTo(walletId))
              .category((q) => q.typeEqualTo(CategoryType.income))
              .amountProperty()
              .sum() -
          await ref
              .watch(isarSourceProvider)
              .instance
              .transactionModels
              .filter()
              .wallet((q) => q.idEqualTo(walletId))
              .category((q) => q.typeEqualTo(CategoryType.expense))
              .amountProperty()
              .sum(),
      totalIncome: await ref
          .watch(isarSourceProvider)
          .instance
          .transactionModels
          .filter()
          .wallet((q) => q.idEqualTo(walletId))
          .category((q) => q.typeEqualTo(CategoryType.income))
          .dateBetween(
            currentDate,
            nextDate,
            includeLower: true,
            includeUpper: false,
          )
          .amountProperty()
          .sum(),
      totalExpense: await ref
          .watch(isarSourceProvider)
          .instance
          .transactionModels
          .filter()
          .wallet((q) => q.idEqualTo(walletId))
          .category((q) => q.typeEqualTo(CategoryType.expense))
          .dateBetween(
            currentDate,
            nextDate,
            includeLower: true,
            includeUpper: false,
          )
          .amountProperty()
          .sum(),
    );
  }

  void _listenStream({
    required int walletId,
    required DateTime currentDate,
    required DateTime nextDate,
  }) {
    StreamSubscription subscription = ref
        .watch(isarSourceProvider)
        .instance
        .transactionModels
        .filter()
        .wallet((q) => q.idEqualTo(walletId))
        .watchLazy()
        .listen((event) async {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(
        () => _read(
          walletId: walletId,
          currentDate: currentDate,
          nextDate: nextDate,
        ),
      );
    });

    ref.onDispose(() => subscription.cancel());
  }
}

final currentWalletProvider =
    AsyncNotifierProvider<CurrentWalletNotifier, CurrentWalletData>(
  CurrentWalletNotifier.new,
);
