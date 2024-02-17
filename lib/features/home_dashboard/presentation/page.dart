import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/all_wallets_summary_view.dart';
import 'widgets/current_wallet_summary_view.dart';
import 'widgets/recent_transactions_view.dart';
import 'widgets/shortcuts_view.dart';

@RoutePage()
class HomeDashboardPage extends HookConsumerWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(16),
          CurrentWalletSummaryView(),
          Gap(8),
          AllWalletsSummaryView(),
          if (false) Gap(8),
          if (false) ShortcutsView(),

          Gap(16),
          RecentTransactionsView(),

          // spacer
          Gap(56 + 32),
        ],
      ),
    );
  }
}
