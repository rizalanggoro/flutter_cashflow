import 'package:auto_route/auto_route.dart';
import 'package:cashflow/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/router/router.gr.dart';
import '../../../shared/presentation/providers/selected_wallet.dart';
import '../domain/entities/navigation_item.dart';

@RoutePage()
class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationItems = <NavigationItem>[
      NavigationItem(
        title: 'Ringkasan',
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard_rounded,
      ),
      NavigationItem(
        title: 'Transaksi',
        icon: Icons.payment_outlined,
        selectedIcon: Icons.payment_rounded,
      ),
      NavigationItem(
        title: 'Grafik',
        icon: Icons.pie_chart_outline_rounded,
        selectedIcon: Icons.pie_chart_rounded,
      ),
      NavigationItem(
        title: 'Setelan',
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings_rounded,
      ),
    ];

    return AutoTabsRouter(
      routes: const [
        HomeDashboardRoute(),
        HomeTransactionRoute(),
        HomeChartRoute(),
        HomeSettingRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 64,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  navigationItems[tabsRouter.activeIndex].title,
                ),
                if (tabsRouter.activeIndex < 3)
                  ref.watch(selectedWalletProvider).maybeWhen(
                      data: (data) => Text(
                            data?.name ?? 'Tidak ada dompet',
                            style: context.textTheme.bodyMedium,
                          ),
                      orElse: () => const SizedBox())
              ],
            ),
            actions: tabsRouter.activeIndex < 3
                ? [
                    if (tabsRouter.activeIndex > 0)
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.sort_rounded),
                      ),
                    IconButton(
                      icon: const Icon(Icons.wallet_rounded),
                      onPressed: () => context.router.push(
                        const SelectWalletRoute(),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ]
                : null,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: tabsRouter.activeIndex,
            onDestinationSelected: (value) => tabsRouter.setActiveIndex(value),
            destinations: navigationItems
                .map((e) => NavigationDestination(
                      icon: Icon(e.icon),
                      selectedIcon: Icon(e.selectedIcon),
                      label: e.title,
                    ))
                .toList(),
          ),
          floatingActionButton: tabsRouter.activeIndex < 3
              ? FloatingActionButton(
                  child: const Icon(Icons.add_rounded),
                  onPressed: () =>
                      context.router.push(const WriteTransactionRoute()),
                )
              : null,
          // body: IndexedStack(
          //   index: selectedNavigationIndex.value,
          //   children: navigationItems.map((e) => e.component).toList(),
          // ),
          body: child,
        );
      },
    );
  }
}
