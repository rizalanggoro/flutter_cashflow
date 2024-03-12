import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/sources/isar.dart';
import 'guards/first_wallet.dart';
import 'router.gr.dart';

@AutoRouterConfig()
class MyRouter extends $MyRouter {
  final WidgetRef ref;

  MyRouter({
    super.navigatorKey,
    required this.ref,
  });

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: HomeRoute.page,
          initial: true,
          guards: [
            FirstWalletGuard(
              isar: ref.watch(isarSourceProvider).instance,
            ),
          ],
          children: [
            AutoRoute(
              page: HomeDashboardRoute.page,
              initial: true,
            ),
            AutoRoute(page: HomeTransactionRoute.page),
            AutoRoute(
              page: HomeChartRoute.page,
              // initial: true,
            ),
            AutoRoute(page: HomeSettingRoute.page),
          ],
        ),

        // wallet
        AutoRoute(
          page: ManageWalletRoute.page,
          // initial: true,
        ),
        AutoRoute(
          page: WriteWalletRoute.page,
          // initial: true,
        ),
        AutoRoute(
          page: SelectWalletRoute.page,
          // initial: true,
        ),

        // category
        AutoRoute(
          page: ManageCategoryRoute.page,
          // initial: true,
        ),
        AutoRoute(
          page: WriteCategoryRoute.page,
          // initial: true,
        ),
        AutoRoute(
          page: SelectCategoryRoute.page,
          // initial: true,
        ),

        // transaction
        AutoRoute(
          page: WriteTransactionRoute.page,
          // initial: true,
        ),
        AutoRoute(
          page: DetailTransactionRoute.page,
          // initial: true,
        ),

        // settings
        AutoRoute(page: SettingAppearanceRoute.page),
        AutoRoute(page: SelectAppearanceColorSchemeRoute.page),
      ];
}
