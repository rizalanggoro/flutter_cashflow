import '../../../../data/models/wallet.dart';

class WalletItem {
  final WalletModel wallet;
  final double totalIncome, totalExpense;

  WalletItem({
    required this.wallet,
    required this.totalIncome,
    required this.totalExpense,
  });
}
