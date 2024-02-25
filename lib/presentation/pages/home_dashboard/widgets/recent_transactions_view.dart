import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/enums/category_type.dart';
import '../../../../core/router/router.gr.dart';
import '../../../../core/utils/extensions.dart';
import '../../../widgets/empty_container.dart';
import '../../../widgets/loading_container.dart';
import '../providers/recent_transactions.dart';

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
        ref.watch(recentTransactionsProvider).maybeWhen(
              loading: () => _loadingContainer,
              data: (data) => data.isEmpty
                  ? _emptyContainer
                  : Column(
                      children: [
                        const Gap(8),
                        ListView.builder(
                          itemBuilder: (context, index) {
                            final transaction = data[index];
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
                              subtitle: transaction.note.isEmpty
                                  ? null
                                  : Text(
                                      transaction.note,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    NumberFormat.compactCurrency().format(
                                      transaction.amount,
                                    ),
                                  ),
                                  Text(
                                    DateFormat.MEd().format(
                                      transaction.date,
                                    ),
                                  ),
                                ],
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
                        const Gap(8),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: OutlinedButton(
                            onPressed: () =>
                                AutoTabsRouter.of(context).setActiveIndex(1),
                            child: const Text('Lihat lainnya'),
                          ),
                        ),
                      ],
                    ),
              orElse: () => _emptyContainer,
            )
      ],
    );
  }

  Widget get _loadingContainer => const LoadingContainer(
        padding: EdgeInsets.all(64),
      );
  Widget get _emptyContainer => const EmptyContainer(
        padding: EdgeInsets.all(64),
      );
}
