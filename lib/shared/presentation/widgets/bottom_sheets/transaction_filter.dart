import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/utils/extensions.dart';
import '../../../domain/entities/transaction_range_filter_item.dart';
import '../../../enums/transaction_range_filter.dart';
import '../../providers/selected_transaction_range_filter.dart';

class BottomSheetTransactionFilter extends HookConsumerWidget {
  const BottomSheetTransactionFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: Text(
              'Rentang waktu',
              style: context.textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: Text(
              'Rentang waktu untuk grafik dan transaksi yang Anda lakukan',
              style: context.textTheme.bodyMedium,
            ),
          ),
          Gap(8),
          ...[
            TransactionRangeFilterItem(
              title: 'Tahunan',
              transactionRangeFilter: TransactionRangeFilter.yearly,
            ),
            TransactionRangeFilterItem(
              title: 'Bulanan',
              transactionRangeFilter: TransactionRangeFilter.monthly,
            ),
            TransactionRangeFilterItem(
              title: 'Harian',
              transactionRangeFilter: TransactionRangeFilter.daily,
            ),
          ].map((e) => RadioListTile(
                value: e.transactionRangeFilter,
                groupValue: ref.watch(selectedTransactionRangeFilterProvider),
                onChanged: (value) {
                  if (value != null) {
                    ref
                        .read(selectedTransactionRangeFilterProvider.notifier)
                        .state = value;
                  }
                },
                title: Text(e.title),
              )),

          // actions
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 32,
              horizontal: 16,
            ),
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: () => context.router.pop(),
              child: const Text('Selesai'),
            ),
          ),
        ],
      ),
    );
  }
}
