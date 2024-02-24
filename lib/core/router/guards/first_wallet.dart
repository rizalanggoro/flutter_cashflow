import 'package:auto_route/auto_route.dart';
import 'package:isar/isar.dart';

import '../../../data/models/wallet.dart';
import '../router.gr.dart';

class FirstWalletGuard extends AutoRouteGuard {
  final Isar _isar;

  FirstWalletGuard({required Isar isar}) : _isar = isar;

  @override
  void onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final isEmpty = await _isar.walletModels.where().isEmpty();
    if (isEmpty) {
      resolver.redirect(
        WriteWalletRoute(isCreateFirstWallet: true),
        replace: true,
      );
    } else {
      resolver.next();
    }
  }
}
