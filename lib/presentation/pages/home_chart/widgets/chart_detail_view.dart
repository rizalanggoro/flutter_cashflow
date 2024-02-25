import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/enums/category_type.dart';
import '../../../../core/enums/transaction_range_filter.dart';
import '../../../../core/router/router.gr.dart';
import '../../../../core/utils/extensions.dart';
import '../../../providers/selected_date_range_filter.dart';
import '../../../widgets/empty_container.dart';
import '../../../widgets/loading_container.dart';
import '../providers/chart_detail_data.dart';
import '../providers/providers.dart';
import '../providers/selected_chart_detail_date.dart';

class ChartDetailView extends HookConsumerWidget {
  const ChartDetailView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartDetailDataSnapshot = ref.watch(chartDetailDataProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Consumer(
                builder: (context, ref, child) {
                  final selectedDetailDate =
                      ref.watch(selectedChartDetailDateProvider);
                  final firstChartDate =
                      ref.watch(selectedFirstChartDateProvider);

                  return IconButton.outlined(
                    onPressed: selectedDetailDate == firstChartDate
                        ? null
                        : () => ref
                            .read(selectedChartDetailDateProvider.notifier)
                            .previous(),
                    icon: const Icon(Icons.chevron_left_rounded),
                  );
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Rincian statistik',
                    style: context.textTheme.titleMedium,
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      final selectedDateRangeFilter =
                          ref.watch(selectedDateRangeFilterProvider);
                      final selectedDetailDate =
                          ref.watch(selectedChartDetailDateProvider);

                      return Text(
                        selectedDetailDate != null
                            ? switch (selectedDateRangeFilter) {
                                DateRangeFilter.yearly => DateFormat.y().format(
                                    selectedDetailDate,
                                  ),
                                DateRangeFilter.monthly =>
                                  DateFormat.yMMMM().format(
                                    selectedDetailDate,
                                  ),
                                DateRangeFilter.daily =>
                                  DateFormat.yMMMEd().format(
                                    selectedDetailDate,
                                  ),
                              }
                            : 'Tidak ada grafik dipilih!',
                        style: context.textTheme.bodySmall,
                      );
                    },
                  ),
                ],
              ),
              Consumer(
                builder: (context, ref, child) {
                  final selectedDetailDate =
                      ref.watch(selectedChartDetailDateProvider);
                  final lastChartDate =
                      ref.watch(selectedLastChartDateProvider);

                  return IconButton.outlined(
                    onPressed: selectedDetailDate == lastChartDate
                        ? null
                        : () => ref
                            .read(selectedChartDetailDateProvider.notifier)
                            .next(),
                    icon: const Icon(Icons.chevron_right_rounded),
                  );
                },
              ),
            ],
          ),
        ),
        chartDetailDataSnapshot.maybeWhen(
          loading: () => const LoadingContainer(
            padding: EdgeInsets.symmetric(vertical: 64),
          ),
          data: (data) => data == null || data.transactions.isEmpty
              ? const EmptyContainer(
                  padding: EdgeInsets.symmetric(vertical: 64),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 12 / 7,
                            child: PieChart(
                              PieChartData(
                                startDegreeOffset: -90,
                                sectionsSpace: 4,
                                sections: [
                                  // income
                                  PieChartSectionData(
                                    value: data.totalIncome,
                                    color: context.colorScheme.primary,
                                    showTitle: false,
                                  ),

                                  // expense
                                  PieChartSectionData(
                                    value: data.totalExpense,
                                    color: context.colorScheme.primaryContainer,
                                    showTitle: false,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(16),

                    // card income, expense
                    Card(
                      margin: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 16,
                            ),
                            child: Text(
                              'Status anggaran',
                              style: context.textTheme.titleMedium,
                            ),
                          ),
                          ListTile(
                            leading: CircleAvatar(
                              child: Icon(
                                data.totalIncome > data.totalExpense
                                    ? Icons.trending_up_rounded
                                    : Icons.trending_down_rounded,
                              ),
                            ),
                            title: Text(
                              data.totalIncome > data.totalExpense
                                  ? 'Suplus'
                                  : 'Defisit',
                            ),
                            subtitle: Text(
                              NumberFormat.currency().format(
                                data.totalIncome - data.totalExpense,
                              ),
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            trailing: const CircleAvatar(
                                child: Icon(Icons.south_west_rounded)),
                            title: const Text('Pemasukan'),
                            subtitle: Text(
                              NumberFormat.currency().format(data.totalIncome),
                            ),
                          ),
                          ListTile(
                            trailing: const CircleAvatar(
                                child: Icon(Icons.north_east_rounded)),
                            title: const Text('Pengeluaran'),
                            subtitle: Text(
                              NumberFormat.currency().format(data.totalExpense),
                            ),
                          ),
                          const Gap(8),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        top: 16,
                        bottom: 8,
                      ),
                      child: Text(
                        'Daftar transaksi',
                        style: context.textTheme.titleMedium,
                      ),
                    ),

                    // transactions
                    ListView.builder(
                      itemBuilder: (context, index) {
                        final transaction = data.transactions[index];
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
                          title: Text(category?.name ?? 'Tidak ada kategori'),
                          subtitle: transaction.note.isNotEmpty
                              ? Text(
                                  transaction.note,
                                  maxLines: 2,
                                )
                              : null,
                          trailing: Text(
                            NumberFormat.compactCurrency().format(
                              transaction.amount,
                            ),
                          ),
                          onTap: () => context.router.push(
                            DetailTransactionRoute(
                              transactionId: transaction.id,
                            ),
                          ),
                        );
                      },
                      itemCount: data.transactions.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                  ],
                ),
          orElse: () => const EmptyContainer(
            padding: EdgeInsets.symmetric(vertical: 64),
          ),
        ),
      ],
    );
  }
}
