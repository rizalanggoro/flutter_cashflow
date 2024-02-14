import 'package:auto_route/auto_route.dart';
import 'package:cashflow/core/utils/extensions.dart';
import 'package:cashflow/shared/enums/transaction_range_filter.dart';
import 'package:cashflow/shared/presentation/providers/selected_transaction_range_filter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

@RoutePage()
class HomeChartPage extends HookConsumerWidget {
  const HomeChartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedBarChartIndex = useState(0);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Row(
              children: [
                IconButton.outlined(
                  onPressed: () {},
                  icon: const Icon(Icons.chevron_left_rounded),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        switch (
                            ref.watch(selectedTransactionRangeFilterProvider)) {
                          TransactionRangeFilter.yearly => 'Tahunan',
                          TransactionRangeFilter.monthly => 'Bulanan',
                          TransactionRangeFilter.daily => 'Harian',
                        },
                        style: context.textTheme.titleMedium,
                      ),
                      Text(
                        '${DateFormat.yMMMEd().format(DateTime.now())} - ${DateFormat.yMMMEd().format(DateTime.now())}',
                        style: context.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton.outlined(
                  onPressed: () {},
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
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                    enabled: true,
                    handleBuiltInTouches: false,
                    touchCallback: (_, response) {
                      final groupIndex = response?.spot?.touchedBarGroupIndex;
                      if (groupIndex != null) {
                        selectedBarChartIndex.value = groupIndex;
                      }
                    },
                  ),
                  gridData: FlGridData(
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  titlesData: FlTitlesData(
                    topTitles: AxisTitles(),
                    rightTitles: AxisTitles(),
                    leftTitles: AxisTitles(),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) =>
                            Text(value.toString()),
                      ),
                    ),
                  ),
                  barGroups: [
                    ...List.generate(
                      7,
                      (index) {
                        final isSelected = index == selectedBarChartIndex.value;

                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: 10 * (index + 1),
                              width: 16,
                              borderRadius: BorderRadius.circular(4),
                              color: isSelected
                                  ? context.colorScheme.primary.withOpacity(.32)
                                  : context.colorScheme.primary,
                              borderSide: BorderSide(
                                color: isSelected
                                    ? context.colorScheme.primary
                                    : Colors.transparent,
                              ),
                            ),
                            BarChartRodData(
                                toY: 3 * (index + 2),
                                width: 16,
                                borderRadius: BorderRadius.circular(4),
                                color: isSelected
                                    ? context.colorScheme.primaryContainer
                                        .withOpacity(.32)
                                    : context.colorScheme.primaryContainer,
                                borderSide: BorderSide(
                                  color: isSelected
                                      ? context.colorScheme.primaryContainer
                                      : Colors.transparent,
                                )),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 64,
              right: 64,
              top: 16,
            ),
            alignment: Alignment.center,
            child: Text(
              'Tekan salah satu bar chart untuk melihat rincian statistik',
              style: context.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          Gap(8),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              top: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rincian statistik',
                  style: context.textTheme.titleMedium,
                ),
                Text(
                  DateFormat.yMMMMEEEEd().format(DateTime.now()),
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
          Gap(16),

          // transactions
          ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(child: Icon(Icons.south_west_rounded)),
                title: Text('Category name $index'),
                subtitle: Text('Transaction note example'),
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

          // spacer
          Gap(56 + 32),
        ],
      ),
    );
  }
}
