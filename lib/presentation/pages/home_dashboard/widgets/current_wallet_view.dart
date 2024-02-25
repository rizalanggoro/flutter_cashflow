import 'package:cashflow/presentation/pages/home_dashboard/providers/balance_visibility.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/extensions.dart';
import '../../../providers/selected_wallet.dart';
import '../../../widgets/empty_container.dart';
import '../../../widgets/loading_container.dart';
import '../providers/current_wallet.dart';

class CurrentWalletView extends HookConsumerWidget {
  const CurrentWalletView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(16),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Text(
              'Dompet saat ini',
              style: context.textTheme.titleMedium,
            ),
          ),
          ref.watch(currentWalletProvider).maybeWhen(
                loading: () => _loadingContainer,
                data: (data) => Column(
                  children: [
                    const Gap(8),
                    ListTile(
                      leading:
                          const CircleAvatar(child: Icon(Icons.wallet_rounded)),
                      title: const Text('Total saldo'),
                      subtitle: Text(
                        ref.watch(balanceVisibilityProvider)
                            ? NumberFormat.currency().format(
                                data.totalBalance,
                              )
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                          const Gap(8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Rincian',
                              style: context.textTheme.titleMedium,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Total pemasukan dan pengeluaran pada dompet ${ref.watch(selectedWalletProvider).maybeWhen(
                                    data: (data) =>
                                        data == null ? '-' : data.name,
                                    orElse: () => '-',
                                  )} selama bulan ${DateFormat.yMMMM().format(DateTime.now())}',
                            ),
                          ),
                          const Gap(8),
                          ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.sync_alt_rounded),
                            ),
                            title: const Text('Selisih anggaran'),
                            subtitle: Text(
                              NumberFormat.currency().format(
                                data.totalIncome - data.totalExpense,
                              ),
                            ),
                          ),
                          const Divider(
                            indent: 16,
                            endIndent: 16,
                          ),
                          ListTile(
                            trailing: const CircleAvatar(
                                child: Icon(Icons.south_west_rounded)),
                            title: const Text('Pemasukan'),
                            subtitle: Text(
                              NumberFormat.currency().format(
                                data.totalIncome,
                              ),
                            ),
                          ),
                          ListTile(
                            trailing: const CircleAvatar(
                                child: Icon(Icons.north_east_rounded)),
                            title: const Text('Pengeluaran'),
                            subtitle: Text(
                              NumberFormat.currency().format(
                                data.totalExpense,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                orElse: () => _emptyContainer,
              ),
          const Gap(8),
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
