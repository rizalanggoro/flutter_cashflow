import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/router/router.gr.dart';
import '../../../core/utils/extensions.dart';
import '../../../domain/entities/home_navigation_item.dart';
import '../../providers/selected_wallet.dart';
import '../../widgets/bottom_sheets/transaction_filter.dart';

final _navigationItems = <HomeNavigationItem>[
  HomeNavigationItem(
    title: 'Ringkasan',
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard_rounded,
  ),
  HomeNavigationItem(
    title: 'Transaksi',
    icon: Icons.payment_outlined,
    selectedIcon: Icons.payment_rounded,
  ),
  HomeNavigationItem(
    title: 'Grafik',
    icon: Icons.pie_chart_outline_rounded,
    selectedIcon: Icons.pie_chart_rounded,
  ),
  HomeNavigationItem(
    title: 'Setelan',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings_rounded,
  ),
];
const _routes = <PageRouteInfo>[
  HomeDashboardRoute(),
  HomeTransactionRoute(),
  HomeChartRoute(),
  HomeSettingRoute(),
];

@RoutePage()
class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => AutoTabsRouter(
        routes: _routes,
        builder: (context, child) {
          final tabsRouter = AutoTabsRouter.of(context);
          final activeIndex = tabsRouter.activeIndex;

          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 64,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _navigationItems[activeIndex].title,
                  ),
                  if (activeIndex < 3) const Gap(2),
                  if (activeIndex < 3)
                    ref.watch(selectedWalletProvider).maybeWhen(
                        data: (data) => Text(
                              data?.name ?? 'Tidak ada dompet',
                              style: context.textTheme.bodyMedium,
                            ),
                        orElse: () => const SizedBox())
                ],
              ),
              actions: activeIndex < 3
                  ? [
                      if (activeIndex > 0)
                        IconButton(
                          onPressed: () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            useSafeArea: true,
                            showDragHandle: true,
                            builder: (context) =>
                                const BottomSheetTransactionFilter(),
                          ),
                          icon: const Icon(Icons.sort_rounded),
                        ),
                      IconButton(
                        icon: const Icon(Icons.wallet_rounded),
                        onPressed: () => context.router.push(
                          const SelectWalletRoute(),
                        ),
                      ),
                      const Gap(16),
                    ]
                  : null,
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: activeIndex,
              onDestinationSelected: (value) =>
                  tabsRouter.setActiveIndex(value),
              destinations: _navigationItems
                  .map((e) => NavigationDestination(
                        icon: Icon(e.icon),
                        selectedIcon: Icon(e.selectedIcon),
                        label: e.title,
                      ))
                  .toList(),
            ),
            floatingActionButton: activeIndex < 3
                ? FloatingActionButton(
                    child: const Icon(Icons.add_rounded),
                    onPressed: () => context.router.push(
                      WriteTransactionRoute(),
                    ),
                  )
                : null,
            body: child,
          );
        },
      );
}
