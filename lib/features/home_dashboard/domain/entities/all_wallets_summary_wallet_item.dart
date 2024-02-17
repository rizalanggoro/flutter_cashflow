import '../../../../shared/data/models/wallet.dart';

class AllWalletsSummaryWalletItem {
  final WalletModel wallet;
  final double totalIncome, totalExpense;

  AllWalletsSummaryWalletItem({
    required this.wallet,
    required this.totalIncome,
    required this.totalExpense,
  });
}
