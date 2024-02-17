import 'package:cashflow/features/home_dashboard/domain/entities/all_wallets_summary_wallet_item.dart';

class AllWalletsSummaryData {
  final double totalBalance;
  final List<AllWalletsSummaryWalletItem> walletItems;

  AllWalletsSummaryData({
    required this.totalBalance,
    required this.walletItems,
  });
}
