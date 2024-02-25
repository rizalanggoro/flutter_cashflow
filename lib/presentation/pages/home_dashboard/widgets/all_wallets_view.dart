import 'package:auto_route/auto_route.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/router.gr.dart';
import '../../../../core/utils/extensions.dart';
import '../../../widgets/empty_container.dart';
import '../../../widgets/loading_container.dart';
import '../providers/all_wallets.dart';
import '../providers/balance_visibility.dart';

class AllWalletsView extends HookConsumerWidget {
  const AllWalletsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Semua dompet',
                        style: context.textTheme.titleMedium,
                      ),
                      Text(
                        'Data seluruh dompet yang Anda miliki',
                        style: context.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const Gap(16),
                IconButton.filledTonal(
                  onPressed: () => context.router.push(
                    const ManageWalletRoute(),
                  ),
                  icon: const Icon(Icons.settings_rounded),
                ),
              ],
            ),
          ),
          ref.watch(allWalletsProvider).maybeWhen(
                loading: () => _loadingContainer,
                data: (data) => Column(
                  children: [
                    const Gap(8),
                    ListTile(
                      leading: const CircleAvatar(
                          child: Icon(Icons.language_rounded)),
                      title: const Text('Total saldo'),
                      subtitle: Text(
                        ref.watch(balanceVisibilityProvider)
                            ? NumberFormat.currency().format(data.totalBalance)
                            : 'IDRXXX.XXX.XXX',
                      ),
                      trailing: IconButton(
                        onPressed: () => ref
                            .read(balanceVisibilityProvider.notifier)
                            .toggle(),
                        icon: Icon(
                          ref.watch(balanceVisibilityProvider)
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                        ),
                      ),
                    ),
                    const Divider(),
                    ExpandablePanel(
                      collapsed: ExpandableButton(
                        child: ListTile(
                          title: Text(
                            'Tampilkan rincian',
                            style: context.textTheme.labelLarge,
                          ),
                          trailing:
                              const Icon(Icons.keyboard_arrow_down_rounded),
                        ),
                      ),
                      expanded: Column(
                        children: [
                          ExpandableButton(
                            child: ListTile(
                              title: Text(
                                'Sembunyikan rincian',
                                style: context.textTheme.labelLarge,
                              ),
                              trailing:
                                  const Icon(Icons.keyboard_arrow_up_rounded),
                            ),
                          ),
                          const Divider(),
                          ListView.builder(
                            itemBuilder: (context, index) {
                              final walletItem = data.walletItems[index];

                              return ListTile(
                                title: Text(walletItem.wallet.name),
                                subtitle: Text(
                                  NumberFormat.currency().format(
                                    walletItem.totalIncome -
                                        walletItem.totalExpense,
                                  ),
                                ),
                              );
                            },
                            itemCount: data.walletItems.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                          ),
                        ],
                      ),
                    ),
                    const Gap(8)
                  ],
                ),
                orElse: () => _emptyContainer,
              ),
        ],
      ),
    );
  }

  Widget get _loadingContainer => const LoadingContainer(
        padding: EdgeInsets.all(64),
      );

  Widget get _emptyContainer => const EmptyContainer(
        padding: EdgeInsets.all(64),
      );
}
