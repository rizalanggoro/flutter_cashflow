import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/extensions.dart';

class RecentTransactionsView extends HookConsumerWidget {
  const RecentTransactionsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Transaksi terbaru',
            style: context.textTheme.titleMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Beberapa transaksi terbaru yang Anda lakukan pada bulan ${DateFormat.yMMMM().format(DateTime.now())}',
          ),
        ),
        const Gap(8),
        ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              leading:
                  const CircleAvatar(child: Icon(Icons.south_west_rounded)),
              title: Text('Nama kategori $index'),
              subtitle: const Text('Catatan transaksi'),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    NumberFormat.compactCurrency().format(120987),
                  ),
                  Text(
                    DateFormat.MEd().format(DateTime.now()),
                  ),
                ],
              ),
              onTap: () {},
            );
          },
          itemCount: 5,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
        const Gap(8),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: OutlinedButton(
            onPressed: () {},
            child: const Text('Lihat lainnya'),
          ),
        ),
      ],
    );
  }
}
