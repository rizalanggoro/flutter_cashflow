import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';

import '../../../core/router/router.gr.dart';
import '../../../core/utils/extensions.dart';
import '../../../shared/data/models/category.dart';
import '../../../shared/data/models/transaction.dart';
import '../../../shared/data/models/wallet.dart';
import '../../../shared/data/sources/isar.dart';
import '../../../shared/enums/category_type.dart';
import '../../../shared/presentation/providers/selected_wallet.dart';
import '../../../shared/presentation/widgets/empty_container.dart';
import '../../../shared/presentation/widgets/failure_container.dart';
import '../../../shared/presentation/widgets/loading_container.dart';
import '../domain/usecases/read_wallets.dart';

@RoutePage()
class HomeDashboardPage extends HookConsumerWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTotalBalance(),
          const Gap(8),
          const Divider(),
          _myWallets(),
          const Divider(),
          _recentTransactions(),

          // spacer
          const SizedBox(height: 56 + 32),
        ],
      ),
    );
  }

  Widget _cardTotalBalance() {
    return HookConsumer(
      builder: (context, ref, child) {
        final snapshotTotalBalance = useFuture(
          useMemoized(
            () async {
              final selectedWalletId =
                  ref.watch(selectedWalletProvider).value?.id;
              if (selectedWalletId != null) {
                final totalIncomes = await ref
                    .watch(isarSourceProvider)
                    .instance
                    .transactionModels
                    .filter()
                    .wallet((q) => q.idEqualTo(selectedWalletId))
                    .category((q) => q.typeEqualTo(CategoryType.income))
                    .amountProperty()
                    .sum();
                print(totalIncomes);
                final totalExpense = await ref
                    .watch(isarSourceProvider)
                    .instance
                    .transactionModels
                    .filter()
                    .wallet((q) => q.idEqualTo(selectedWalletId))
                    .category((q) => q.typeEqualTo(CategoryType.expense))
                    .amountProperty()
                    .sum();
                print(totalExpense);
                return totalIncomes + totalExpense;
              }
            },
            [ref.watch(selectedWalletProvider)],
          ),
        );

        return Card(
          margin: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(8),
              ListTile(
                title: const Text('Saldo Anda'),
                subtitle: Text(
                  NumberFormat.currency(locale: 'id').format(
                    switch (snapshotTotalBalance.connectionState) {
                      ConnectionState.done => snapshotTotalBalance.data ?? 0,
                      _ => 0,
                    },
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.visibility_rounded),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.south_west_rounded),
                ),
                title: const Text('Pemasukan'),
                subtitle: Text(
                  NumberFormat.currency(locale: 'id').format(12987087),
                ),
              ),
              ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.north_east_rounded),
                ),
                title: const Text('Pengeluaran'),
                subtitle: Text(
                  NumberFormat.currency(locale: 'id').format(12987087),
                ),
              ),
              const Gap(8),
            ],
          ),
        );
      },
    );
  }

  Widget _myWallets() => HookConsumer(
        builder: (context, ref, child) {
          final walletsSnapshot = useFuture(useMemoized(
            () => ref.watch(readWalletsUseCaseProvider).call(),
            [],
          ));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dompet Saya',
                      style: context.textTheme.titleMedium,
                    ),
                    OutlinedButton(
                      onPressed: () =>
                          context.router.push(const ManageWalletRoute()),
                      child: const Text('Lainnya'),
                    ),
                  ],
                ),
              ),
              switch (walletsSnapshot.connectionState) {
                ConnectionState.waiting => const LoadingContainer(
                    padding: EdgeInsets.all(32),
                  ),
                ConnectionState.done => walletsSnapshot.data?.fold(
                      (l) => FailureContainer(message: l.message),
                      (r) => r.isEmpty
                          ? const EmptyContainer(
                              padding: EdgeInsets.all(32),
                            )
                          : ListView.builder(
                              itemBuilder: (context, index) {
                                final wallet = r[index];

                                return ListTile(
                                  title: Text(wallet.name),
                                  subtitle: FutureBuilder(
                                    future: wallet.transactions.count(),
                                    builder: (context, snapshot) {
                                      final count = snapshot.data ?? 0;
                                      return Text(Intl.plural(
                                        count,
                                        zero: 'Tidak ada transaksi',
                                        other: '$count transaksi',
                                      ));
                                    },
                                  ),
                                  trailing: Text(
                                    NumberFormat.compactCurrency()
                                        .format(125000 * (index + 1)),
                                  ),
                                );
                              },
                              itemCount: r.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                            ),
                    ) ??
                    const EmptyContainer(
                      padding: EdgeInsets.all(32),
                    ),
                _ => const EmptyContainer(
                    padding: EdgeInsets.all(32),
                  ),
              },
            ],
          );
        },
      );

  Widget _recentTransactions() {
    return HookConsumer(
      builder: (context, ref, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transaksi baru-baru ini',
                  style: context.textTheme.titleMedium,
                ),
                OutlinedButton(
                  onPressed: () => AutoTabsRouter.of(context).setActiveIndex(1),
                  child: const Text('Lainnya'),
                ),
              ],
            ),
          ),
          ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.south_west_rounded),
                ),
                title: Text('Category $index'),
                subtitle: Text(
                  NumberFormat.currency(locale: 'id')
                      .format(125000 * (index + 1)),
                ),
              );
            },
            itemCount: 5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ],
      ),
    );
  }
}
