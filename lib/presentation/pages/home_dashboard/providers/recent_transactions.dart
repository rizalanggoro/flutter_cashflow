import 'dart:async';

import 'package:cashflow/core/failure/failure.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../data/models/transaction.dart';
import '../../../../data/models/wallet.dart';
import '../../../../data/sources/isar.dart';
import '../../../providers/selected_wallet.dart';

class RecentTransactionsNotifier extends AsyncNotifier<List<TransactionModel>> {
  @override
  Future<List<TransactionModel>> build() async {
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

  Future<List<TransactionModel>> _read({
    required int walletId,
    required DateTime currentDate,
    required DateTime nextDate,
  }) async {
    return await ref
        .watch(isarSourceProvider)
        .instance
        .transactionModels
        .filter()
        .wallet((q) => q.idEqualTo(walletId))
        .dateBetween(
          currentDate,
          nextDate,
          includeLower: true,
          includeUpper: false,
        )
        .sortByDateDesc()
        .limit(5)
        .findAll();
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
        .dateBetween(
          currentDate,
          nextDate,
          includeLower: true,
          includeUpper: false,
        )
        .sortByDateDesc()
        .limit(5)
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

final recentTransactionsProvider =
    AsyncNotifierProvider<RecentTransactionsNotifier, List<TransactionModel>>(
  RecentTransactionsNotifier.new,
);
