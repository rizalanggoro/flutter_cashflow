import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/extensions.dart';

class ShortcutsView extends HookConsumerWidget {
  const ShortcutsView({super.key});

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
                        'Pintasan',
                        style: context.textTheme.titleMedium,
                      ),
                      Text(
                        'Tambahkan transaksi favorit Anda secara cepat',
                        style: context.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const Gap(16),
                IconButton.filledTonal(
                  onPressed: () {},
                  icon: const Icon(Icons.settings_rounded),
                ),
              ],
            ),
          ),
          const Gap(8),
          ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.south_west_rounded),
                ),
                title: Text('Nama kategori $index'),
                subtitle: Text('Catatan singkat'),
                trailing: Text(NumberFormat.compactCurrency().format(2000)),
                onTap: () {},
              );
            },
            itemCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
          const Gap(16),
        ],
      ),
    );
  }
}
