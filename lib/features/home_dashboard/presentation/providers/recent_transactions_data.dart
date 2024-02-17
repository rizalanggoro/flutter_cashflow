import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../shared/data/models/transaction.dart';
import '../../../../shared/data/models/wallet.dart';
import '../../../../shared/data/sources/isar.dart';
import '../../../../shared/presentation/providers/selected_wallet.dart';

class RecentTransactionsNotifier extends AsyncNotifier<List<TransactionModel>> {
  @override
  Future<List<TransactionModel>> build() async {
    final walletId = ref.watch(selectedWalletProvider).value?.id;
    if (walletId != null) {
      final currentDate = DateTime(
        DateTime.now().year,
        DateTime.now().month,
      );
      final nextDate = DateTime(
        currentDate.year,
        currentDate.month + 1,
      );

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

    return [];
  }
}

final recentTransactionsDataProvider =
    AsyncNotifierProvider<RecentTransactionsNotifier, List<TransactionModel>>(
  RecentTransactionsNotifier.new,
);
