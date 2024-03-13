import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/enums/transaction_range_filter.dart';
import '../../../core/utils/extensions.dart';
import '../../models/transaction_range_filter_item.dart';
import '../../providers/selected_date_range_filter.dart';

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
          const Gap(8),
          ...[
            TransactionRangeFilterItem(
              title: 'Tahunan',
              transactionRangeFilter: DateRangeFilter.yearly,
            ),
            TransactionRangeFilterItem(
              title: 'Bulanan',
              transactionRangeFilter: DateRangeFilter.monthly,
            ),
            TransactionRangeFilterItem(
              title: 'Harian',
              transactionRangeFilter: DateRangeFilter.daily,
            ),
          ].map((e) => RadioListTile(
                value: e.transactionRangeFilter,
                groupValue: ref.watch(selectedDateRangeFilterProvider),
                onChanged: (value) {
                  if (value != null) {
                    ref.read(selectedDateRangeFilterProvider.notifier).state =
                        value;
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
