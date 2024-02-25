import 'dart:async';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/enums/category_type.dart';
import '../../../core/enums/transaction_range_filter.dart';
import '../../../core/router/router.gr.dart';
import '../../../core/utils/extensions.dart';
import '../../../domain/usecases/read_transactions.dart';
import '../../../domain/usecases/watch_transactions.dart';
import '../../providers/selected_date_range_filter.dart';
import '../../providers/selected_wallet.dart';
import '../../widgets/empty_container.dart';
import '../../widgets/failure_container.dart';
import '../../widgets/loading_container.dart';

@RoutePage()
class HomeTransactionPage extends HookConsumerWidget {
  const HomeTransactionPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('build: home transaction view');

    // global state
    final selectedTransactionRangeFilter =
        ref.watch(selectedDateRangeFilterProvider);

    final yearlyDate = useState(DateTime.now());
    final monthlyDate = useState(DateTime.now());
    final dailyDate = useState(DateTime.now());

    final snapshotTransactionsRefreshKey = useState(UniqueKey());
    final snapshotTransactions = useFuture(
      useMemoized(
        () => ref.read(readTransactionsUseCaseProvider).call(
              walletId: ref.watch(selectedWalletProvider).value?.id,
              rangeFilter: selectedTransactionRangeFilter,
              dateTime: switch (selectedTransactionRangeFilter) {
                DateRangeFilter.yearly => yearlyDate.value,
                DateRangeFilter.monthly => monthlyDate.value,
                DateRangeFilter.daily => dailyDate.value,
              },
            ),
        [
          ref.watch(selectedWalletProvider),
          selectedTransactionRangeFilter,
          yearlyDate.value,
          monthlyDate.value,
          dailyDate.value,
          snapshotTransactionsRefreshKey.value,
        ],
      ),
    );

    // stream transactions
    useEffect(() {
      StreamSubscription? subscription;

      ref
          .read(watchTransactionsUseCaseProvider)
          .call(walletId: ref.watch(selectedWalletProvider).value?.id)
          .fold(
            (l) => null,
            (r) => subscription = r.listen(
                (event) => snapshotTransactionsRefreshKey.value = UniqueKey()),
          );

      return () => subscription?.cancel();
    }, [
      ref.watch(selectedWalletProvider),
    ]);

    return Column(
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
                onPressed: () {
                  switch (selectedTransactionRangeFilter) {
                    case DateRangeFilter.yearly:
                      yearlyDate.value = _changeDate(
                        isAdd: false,
                        current: yearlyDate.value,
                        rangeFilter: selectedTransactionRangeFilter,
                      );
                      break;
                    case DateRangeFilter.monthly:
                      monthlyDate.value = _changeDate(
                        isAdd: false,
                        current: monthlyDate.value,
                        rangeFilter: selectedTransactionRangeFilter,
                      );
                      break;
                    case DateRangeFilter.daily:
                      dailyDate.value = _changeDate(
                        isAdd: false,
                        current: dailyDate.value,
                        rangeFilter: selectedTransactionRangeFilter,
                      );
                      break;
                  }
                },
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
                    DateFormat(
                      switch (selectedTransactionRangeFilter) {
                        DateRangeFilter.yearly => 'yyyy',
                        DateRangeFilter.monthly => 'MMMM, yyyy',
                        DateRangeFilter.daily => 'EEEE, d MMMM yyyy',
                      },
                    ).format(
                      switch (selectedTransactionRangeFilter) {
                        DateRangeFilter.yearly => yearlyDate.value,
                        DateRangeFilter.monthly => monthlyDate.value,
                        DateRangeFilter.daily => dailyDate.value,
                      },
                    ),
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),
              IconButton.outlined(
                onPressed: () {
                  switch (selectedTransactionRangeFilter) {
                    case DateRangeFilter.yearly:
                      yearlyDate.value = _changeDate(
                        isAdd: true,
                        current: yearlyDate.value,
                        rangeFilter: selectedTransactionRangeFilter,
                      );
                      break;
                    case DateRangeFilter.monthly:
                      monthlyDate.value = _changeDate(
                        isAdd: true,
                        current: monthlyDate.value,
                        rangeFilter: selectedTransactionRangeFilter,
                      );
                      break;
                    case DateRangeFilter.daily:
                      dailyDate.value = _changeDate(
                        isAdd: true,
                        current: dailyDate.value,
                        rangeFilter: selectedTransactionRangeFilter,
                      );
                      break;
                  }
                },
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
        ),

        // content
        Expanded(
          child: switch (snapshotTransactions.connectionState) {
            ConnectionState.waiting => const LoadingContainer(),
            ConnectionState.done => snapshotTransactions.data?.fold(
                  (l) => FailureContainer(message: l.message),
                  (r) => r.isEmpty
                      ? const EmptyContainer()
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 56 + 32),
                          itemBuilder: (context, index) {
                            final transaction = r[index];
                            final category = transaction.category.value;
                            final categoryType = category?.type;

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: categoryType != null &&
                                        categoryType.isExpense
                                    ? context.colorScheme.errorContainer
                                    : context.colorScheme.primaryContainer,
                                foregroundColor: categoryType != null &&
                                        categoryType.isExpense
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
                          itemCount: r.length,
                        ),
                ) ??
                const EmptyContainer(),
            _ => const EmptyContainer(),
          },
        ),
      ],
    );
  }

  DateTime _changeDate({
    required bool isAdd,
    required DateTime current,
    required DateRangeFilter rangeFilter,
  }) =>
      switch (rangeFilter) {
        DateRangeFilter.yearly => DateTime(
            isAdd ? current.year + 1 : current.year - 1,
          ),
        DateRangeFilter.monthly => DateTime(
            current.year,
            isAdd ? current.month + 1 : current.month - 1,
          ),
        DateRangeFilter.daily => DateTime(
            current.year,
            current.month,
            isAdd ? current.day + 1 : current.day - 1,
          ),
      };
}
