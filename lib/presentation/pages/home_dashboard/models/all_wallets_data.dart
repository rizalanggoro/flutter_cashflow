import 'wallet_item.dart';

class AllWalletsData {
  final double totalBalance;
  final List<WalletItem> walletItems;

  AllWalletsData({
    required this.totalBalance,
    required this.walletItems,
  });
}
