import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../data/models/category.dart';
import '../../../../data/models/transaction.dart';
import '../../../../data/models/wallet.dart';
import '../../../../data/sources/isar.dart';
import '../../../../core/enums/category_type.dart';
import '../../domain/entities/all_wallets_summary_data.dart';
import '../../domain/entities/all_wallets_summary_wallet_item.dart';

class AllWalletsSummaryDataNotifier
    extends AsyncNotifier<AllWalletsSummaryData?> {
  @override
  Future<AllWalletsSummaryData?> build() async {
    _listenStreamSubscription();
    return _read();
  }

  Future<AllWalletsSummaryData> _read() async {
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

    final List<AllWalletsSummaryWalletItem> walletItems = [];
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

      walletItems.add(AllWalletsSummaryWalletItem(
        wallet: wallet,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
      ));
    }

    return AllWalletsSummaryData(
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

final allWalletsSummaryDataProvider = AsyncNotifierProvider<
    AllWalletsSummaryDataNotifier, AllWalletsSummaryData?>(
  AllWalletsSummaryDataNotifier.new,
);
