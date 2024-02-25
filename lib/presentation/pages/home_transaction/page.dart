import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/enums/category_type.dart';
import '../../../core/enums/transaction_range_filter.dart';
import '../../../core/router/router.gr.dart';
import '../../../core/utils/extensions.dart';
import '../../providers/selected_date_range_filter.dart';
import '../../widgets/empty_container.dart';
import '../../widgets/loading_container.dart';
import 'providers/selected_transaction_date.dart';
import 'providers/transactions.dart';

@RoutePage()
class HomeTransactionPage extends HookConsumerWidget {
  const HomeTransactionPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('build: home transaction view');

    // global state
    final selectedTransactionRangeFilter =
        ref.watch(selectedDateRangeFilterProvider);
    final selectedTransactionDate = ref.watch(selectedTransactionDateProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // date range filter
          Container(
            margin: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton.outlined(
                  onPressed: () => ref
                      .read(selectedTransactionDateProvider.notifier)
                      .previous(),
                  icon: const Icon(Icons.chevron_left_rounded),
                ),
                Column(
                  children: [
                    Text(
                      switch (selectedTransactionRangeFilter) {
                        DateRangeFilter.yearly => 'Tahunan',
                        DateRangeFilter.monthly => 'Bulanan',
                        DateRangeFilter.daily => 'Harian',
                      },
                      style: context.textTheme.titleMedium,
                    ),
                    Text(
                      switch (selectedTransactionRangeFilter) {
                        DateRangeFilter.yearly => DateFormat.y().format(
                            selectedTransactionDate.yearly,
                          ),
                        DateRangeFilter.monthly => DateFormat.yMMMM().format(
                            selectedTransactionDate.monthly,
                          ),
                        DateRangeFilter.daily => DateFormat.yMMMMEEEEd()
                            .format(selectedTransactionDate.daily),
                      },
                      style: context.textTheme.bodySmall,
                    ),
                  ],
                ),
                IconButton.outlined(
                  onPressed: () =>
                      ref.read(selectedTransactionDateProvider.notifier).next(),
                  icon: const Icon(Icons.chevron_right_rounded),
                ),
              ],
            ),
          ),

          // list transactions
          ref.watch(transactionsProvider).maybeWhen(
                loading: () => _loadingContainer,
                data: (data) => data.isEmpty
                    ? _emptyContainer
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 56 + 32),
                        itemBuilder: (context, index) {
                          final transaction = data[index];
                          final category = transaction.category.value;
                          final categoryType = category?.type;

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  categoryType != null && categoryType.isExpense
                                      ? context.colorScheme.errorContainer
                                      : context.colorScheme.primaryContainer,
                              foregroundColor:
                                  categoryType != null && categoryType.isExpense
                                      ? context.colorScheme.onErrorContainer
                                      : context.colorScheme.onPrimaryContainer,
                              child: Icon(
                                categoryType == null
                                    ? Icons.remove_rounded
                                    : (categoryType.isIncome
                                        ? Icons.south_west_rounded
                                        : Icons.north_east_rounded),
                              ),
                            ),
                            title: Text(
                              category?.name ?? 'Tidak ada kategori',
                            ),
                            subtitle: transaction.note.isNotEmpty
                                ? Text(
                                    transaction.note,
                                    maxLines: 1,
                                  )
                                : null,
                            trailing: Text(
                              NumberFormat.compactCurrency(locale: 'id')
                                  .format(transaction.amount),
                            ),
                            onTap: () => context.router.push(
                              DetailTransactionRoute(
                                transactionId: transaction.id,
                              ),
                            ),
                          );
                        },
                        itemCount: data.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                orElse: () => _emptyContainer,
              ),
        ],
      ),
    );
  }

  Widget get _emptyContainer => const EmptyContainer(
        padding: EdgeInsets.all(64),
      );

  Widget get _loadingContainer => const LoadingContainer(
        padding: EdgeInsets.all(64),
      );
}
