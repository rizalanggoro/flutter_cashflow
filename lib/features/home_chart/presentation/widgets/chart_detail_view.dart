import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../shared/enums/transaction_range_filter.dart';
import '../../../../shared/presentation/providers/selected_date_range_filter.dart';
import '../providers/selected_chart_detail_date.dart';

class ChartDetailView extends HookConsumerWidget {
  const ChartDetailView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton.outlined(
                onPressed: () =>
                    ref.read(selectedChartDetailDateProvider.notifier).prev(),
                icon: const Icon(Icons.chevron_left_rounded),
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
                        switch (selectedDateRangeFilter) {
                          DateRangeFilter.yearly => DateFormat.y().format(
                              selectedDetailDate,
                            ),
                          DateRangeFilter.monthly => DateFormat.yMMMM().format(
                              selectedDetailDate,
                            ),
                          DateRangeFilter.daily => DateFormat.yMMMEd().format(
                              selectedDetailDate,
                            ),
                        },
                        style: context.textTheme.bodySmall,
                      );
                    },
                  ),
                ],
              ),
              IconButton.outlined(
                onPressed: () =>
                    ref.read(selectedChartDetailDateProvider.notifier).next(),
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
          ),
          child: AspectRatio(
            aspectRatio: 12 / 7,
            child: PieChart(
              PieChartData(
                startDegreeOffset: -90,
                sectionsSpace: 4,
                sections: [
                  // income
                  PieChartSectionData(
                    value: 10,
                    color: context.colorScheme.primary,
                  ),

                  // expense
                  PieChartSectionData(
                    value: 20,
                    color: context.colorScheme.primaryContainer,
                  ),
                ],
              ),
            ),
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
                leading: const CircleAvatar(
                  child: Icon(Icons.trending_down_rounded),
                ),
                title: const Text('Defisit'),
                subtitle: Text(NumberFormat.currency().format(-12000)),
              ),
              const Divider(),
              ListTile(
                leading:
                    const CircleAvatar(child: Icon(Icons.south_west_rounded)),
                title: const Text('Pemasukan'),
                subtitle: Text(NumberFormat.currency().format(12000)),
              ),
              ListTile(
                leading:
                    const CircleAvatar(child: Icon(Icons.north_east_rounded)),
                title: const Text('Pengeluaran'),
                subtitle: Text(NumberFormat.currency().format(12000)),
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
            return ListTile(
              leading:
                  const CircleAvatar(child: Icon(Icons.south_west_rounded)),
              title: Text('Category name $index'),
              subtitle: const Text('Transaction note example'),
              trailing: Text(
                NumberFormat.compactCurrency().format(12000),
              ),
              onTap: () {},
            );
          },
          itemCount: 5,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }
}
