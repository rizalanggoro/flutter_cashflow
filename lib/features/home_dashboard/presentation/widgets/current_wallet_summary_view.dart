import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../shared/presentation/providers/selected_wallet.dart';

class CurrentWalletSummaryView extends HookConsumerWidget {
  const CurrentWalletSummaryView({super.key});

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
          const Gap(8),
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.wallet_rounded)),
            title: const Text('Total saldo'),
            subtitle: Text(
              NumberFormat.currency().format(12345000),
            ),
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.visibility_rounded),
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
                trailing: const Icon(Icons.keyboard_arrow_down_rounded),
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
                    trailing: const Icon(Icons.keyboard_arrow_up_rounded),
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
                          data: (data) => data == null ? '-' : data.name,
                          orElse: () => '-',
                        )} selama bulan ${DateFormat.yMMMM().format(DateTime.now())}',
                  ),
                ),
                const Gap(16),
                ListTile(
                  trailing:
                      const CircleAvatar(child: Icon(Icons.south_west_rounded)),
                  title: const Text('Pemasukan'),
                  subtitle: Text(NumberFormat.currency().format(1234567)),
                ),
                ListTile(
                  trailing:
                      const CircleAvatar(child: Icon(Icons.north_east_rounded)),
                  title: const Text('Pengeluaran'),
                  subtitle: Text(NumberFormat.currency().format(1234567)),
                ),
              ],
            ),
          ),
          const Gap(8),
        ],
      ),
    );
  }
}
