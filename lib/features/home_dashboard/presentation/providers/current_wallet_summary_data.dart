import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../shared/data/models/category.dart';
import '../../../../shared/data/models/transaction.dart';
import '../../../../shared/data/models/wallet.dart';
import '../../../../shared/data/sources/isar.dart';
import '../../../../shared/enums/category_type.dart';
import '../../../../shared/presentation/providers/selected_wallet.dart';
import '../../domain/entities/current_wallet_summary_data.dart';

class CurrentWalletSummaryDataNotifier
    extends AsyncNotifier<CurrentWalletSummaryData?> {
  @override
  Future<CurrentWalletSummaryData?> build() async {
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

      return CurrentWalletSummaryData(
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

    return null;
  }
}

final currentWalletSummaryDataProvider = AsyncNotifierProvider<
    CurrentWalletSummaryDataNotifier, CurrentWalletSummaryData?>(
  CurrentWalletSummaryDataNotifier.new,
);
