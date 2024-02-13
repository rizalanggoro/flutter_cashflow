import 'dart:async';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:cashflow/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/router/router.gr.dart';
import '../../../shared/enums/category_type.dart';
import '../../../shared/enums/transaction_range_filter.dart';
import '../../../shared/presentation/providers/selected_wallet.dart';
import '../../../shared/presentation/widgets/empty_container.dart';
import '../../../shared/presentation/widgets/failure_container.dart';
import '../../../shared/presentation/widgets/loading_container.dart';
import '../domain/usecases/read_transactions.dart';
import '../domain/usecases/watch_transactions.dart';

@RoutePage()
class HomeTransactionPage extends HookConsumerWidget {
  const HomeTransactionPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('build: home transaction view');

    final transactionRangeFilter = useState(TransactionRangeFilter.monthly);
    final yearlyDate = useState(DateTime.now());
    final monthlyDate = useState(DateTime.now());
    final dailyDate = useState(DateTime.now());

    final snapshotTransactionsRefreshKey = useState(UniqueKey());
    final snapshotTransactions = useFuture(
      useMemoized(
        () => ref.read(readTransactionsUseCaseProvider).call(
              walletId: ref.watch(selectedWalletProvider).value?.id,
              rangeFilter: transactionRangeFilter.value,
              dateTime: switch (transactionRangeFilter.value) {
                TransactionRangeFilter.yearly => yearlyDate.value,
                TransactionRangeFilter.monthly => monthlyDate.value,
                TransactionRangeFilter.daily => dailyDate.value,
              },
            ),
        [
          ref.watch(selectedWalletProvider),
          transactionRangeFilter.value,
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
        // range filter
        Container(
          margin: const EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          width: double.infinity,
          child: SegmentedButton(
            segments: const [
              ButtonSegment(
                value: TransactionRangeFilter.yearly,
                label: Text('Tahunan'),
              ),
              ButtonSegment(
                value: TransactionRangeFilter.monthly,
                label: Text('Bulanan'),
              ),
              ButtonSegment(
                value: TransactionRangeFilter.daily,
                label: Text('Harian'),
              ),
            ],
            selected: {transactionRangeFilter.value},
            onSelectionChanged: (setValue) =>
                transactionRangeFilter.value = setValue.first,
          ),
        ),

        // date range filter
        Container(
          margin: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
            bottom: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton.outlined(
                onPressed: () {
                  switch (transactionRangeFilter.value) {
                    case TransactionRangeFilter.yearly:
                      yearlyDate.value = _changeDate(
                        isAdd: false,
                        current: yearlyDate.value,
                        rangeFilter: transactionRangeFilter.value,
                      );
                      break;
                    case TransactionRangeFilter.monthly:
                      monthlyDate.value = _changeDate(
                        isAdd: false,
                        current: monthlyDate.value,
                        rangeFilter: transactionRangeFilter.value,
                      );
                      break;
                    case TransactionRangeFilter.daily:
                      dailyDate.value = _changeDate(
                        isAdd: false,
                        current: dailyDate.value,
                        rangeFilter: transactionRangeFilter.value,
                      );
                      break;
                  }
                },
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Text(
                DateFormat(
                  switch (transactionRangeFilter.value) {
                    TransactionRangeFilter.yearly => 'yyyy',
                    TransactionRangeFilter.monthly => 'MMMM, yyyy',
                    TransactionRangeFilter.daily => 'EEEE, d MMMM yyyy',
                  },
                ).format(
                  switch (transactionRangeFilter.value) {
                    TransactionRangeFilter.yearly => yearlyDate.value,
                    TransactionRangeFilter.monthly => monthlyDate.value,
                    TransactionRangeFilter.daily => dailyDate.value,
                  },
                ),
                style: context.textTheme.titleMedium,
              ),
              IconButton.outlined(
                onPressed: () {
                  switch (transactionRangeFilter.value) {
                    case TransactionRangeFilter.yearly:
                      yearlyDate.value = _changeDate(
                        isAdd: true,
                        current: yearlyDate.value,
                        rangeFilter: transactionRangeFilter.value,
                      );
                      break;
                    case TransactionRangeFilter.monthly:
                      monthlyDate.value = _changeDate(
                        isAdd: true,
                        current: monthlyDate.value,
                        rangeFilter: transactionRangeFilter.value,
                      );
                      break;
                    case TransactionRangeFilter.daily:
                      dailyDate.value = _changeDate(
                        isAdd: true,
                        current: dailyDate.value,
                        rangeFilter: transactionRangeFilter.value,
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
                          itemBuilder: (context, index) {
                            final transaction = r[index];
                            final category = transaction.category.value;
                            final categoryType = category?.type;

                            return ListTile(
                              leading: CircleAvatar(
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
    required TransactionRangeFilter rangeFilter,
  }) =>
      switch (rangeFilter) {
        TransactionRangeFilter.yearly => DateTime(
            isAdd ? current.year + 1 : current.year - 1,
          ),
        TransactionRangeFilter.monthly => DateTime(
            current.year,
            isAdd ? current.month + 1 : current.month - 1,
          ),
        TransactionRangeFilter.daily => DateTime(
            current.year,
            current.month,
            isAdd ? current.day + 1 : current.day - 1,
          ),
      };
}
