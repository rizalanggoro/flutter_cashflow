import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/preferences.dart';

@RoutePage()
class SettingDashboardPage extends HookConsumerWidget {
  const SettingDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ringkasan'),
      ),
      body: Column(
        children: [
          SwitchListTile(
            value: ref.watch(preferencesProvider
                .select((value) => value.dashboardShowCurrentWalletCard)),
            onChanged: (value) => ref
                .read(preferencesProvider.notifier)
                .toggleCurrentWalletSummaryCardVisibility(),
            title: const Text('Dompet saat ini'),
            subtitle: const Text(
              'Tampilkan widget ringkasan untuk dompet saat ini',
            ),
            secondary: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.widgets_outlined),
            ),
          ),
          SwitchListTile(
            value: ref.watch(preferencesProvider
                .select((value) => value.dashboardShowAllWalletsCard)),
            onChanged: (value) => ref
                .read(preferencesProvider.notifier)
                .toggleAllWalletsSummaryCardVisibility(),
            title: const Text('Semua dompet'),
            subtitle: const Text(
              'Tampilkan widget ringkasan saldo untuk semua dompet',
            ),
            secondary: const CircleAvatar(
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
