import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/preferences.dart';
import 'widgets/all_wallets_view.dart';
import 'widgets/current_wallet_view.dart';
import 'widgets/recent_transactions_view.dart';

@RoutePage()
class HomeDashboardPage extends HookConsumerWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWalletSummaryCardVisible = ref.watch(
      preferencesProvider.select(
        (value) => value.dashboardShowCurrentWalletCard,
      ),
    );
    final allWalletsSummaryCardVisible = ref.watch(
      preferencesProvider.select(
        (value) => value.dashboardShowAllWalletsCard,
      ),
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(
            currentWalletSummaryCardVisible || allWalletsSummaryCardVisible
                ? 16
                : 0,
          ),
          if (currentWalletSummaryCardVisible) const CurrentWalletView(),
          Gap(
            currentWalletSummaryCardVisible && allWalletsSummaryCardVisible
                ? 8
                : 0,
          ),
          if (allWalletsSummaryCardVisible) const AllWalletsView(),

          const Gap(16),
          const RecentTransactionsView(),

          // spacer
          const Gap(56 + 32),
        ],
      ),
    );
  }
}
