import 'package:auto_route/auto_route.dart';
import 'package:cashflow/core/router/router.gr.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/extensions.dart';

class AllWalletsSummaryView extends HookConsumerWidget {
  const AllWalletsSummaryView({super.key});

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
                        'Mencakup seluruh dompet yang Anda miliki',
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
          const Gap(8),
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.language_rounded)),
            title: const Text('Total saldo'),
            subtitle: Text(NumberFormat.currency().format(12345678)),
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
                ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Nama dompet $index'),
                      subtitle: Text(NumberFormat.currency().format(12345)),
                    );
                  },
                  itemCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
