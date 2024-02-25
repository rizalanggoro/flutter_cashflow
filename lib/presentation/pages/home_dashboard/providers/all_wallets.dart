import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../core/enums/category_type.dart';
import '../../../../data/models/category.dart';
import '../../../../data/models/transaction.dart';
import '../../../../data/models/wallet.dart';
import '../../../../data/sources/isar.dart';
import '../models/all_wallets_data.dart';
import '../models/wallet_item.dart';

class AllWalletsNotifier extends AsyncNotifier<AllWalletsData> {
  @override
  Future<AllWalletsData> build() async {
    _listenStreamSubscription();
    return _read();
  }

  Future<AllWalletsData> _read() async {
    final totalIncome = await ref
        .watch(isarSourceProvider)
        .instance
        .transactionModels
        .filter()
        .category((q) => q.typeEqualTo(CategoryType.income))
        .amountProperty()
        .sum();
    final totalExpense = await ref
        .watch(isarSourceProvider)
        .instance
        .transactionModels
        .filter()
        .category((q) => q.typeEqualTo(CategoryType.expense))
        .amountProperty()
        .sum();

    final List<WalletItem> walletItems = [];
    final wallets = await ref
        .watch(isarSourceProvider)
        .instance
        .walletModels
        .where()
        .sortByName()
        .findAll();
    for (final wallet in wallets) {
      final totalIncome = await ref
          .watch(isarSourceProvider)
          .instance
          .transactionModels
          .filter()
          .wallet((q) => q.idEqualTo(wallet.id))
          .category((q) => q.typeEqualTo(CategoryType.income))
          .amountProperty()
          .sum();
      final totalExpense = await ref
          .watch(isarSourceProvider)
          .instance
          .transactionModels
          .filter()
          .wallet((q) => q.idEqualTo(wallet.id))
          .category((q) => q.typeEqualTo(CategoryType.expense))
          .amountProperty()
          .sum();

      walletItems.add(WalletItem(
        wallet: wallet,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
      ));
    }

    return AllWalletsData(
      totalBalance: totalIncome - totalExpense,
      walletItems: walletItems,
    );
  }

  void _listenStreamSubscription() {
    StreamSubscription subscription = ref
        .watch(isarSourceProvider)
        .instance
        .transactionModels
        .watchLazy()
        .listen((event) async {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() => _read());
    });

    ref.onDispose(() => subscription.cancel());
  }
}

final allWalletsProvider =
    AsyncNotifierProvider<AllWalletsNotifier, AllWalletsData>(
  AllWalletsNotifier.new,
);
