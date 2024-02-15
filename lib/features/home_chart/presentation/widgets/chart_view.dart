import 'package:cashflow/features/home_chart/presentation/providers/selected_chart_detail_date.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../shared/enums/transaction_range_filter.dart';
import '../../../../shared/presentation/providers/selected_date_range_filter.dart';
import '../../../../shared/presentation/widgets/empty_container.dart';
import '../../../../shared/presentation/widgets/loading_container.dart';
import '../providers/providers.dart';

class ChartView extends HookConsumerWidget {
  const ChartView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDateRangeFilter = ref.watch(selectedDateRangeFilterProvider);

    return Column(
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
                onPressed: () =>
                    ref.read(selectedChartDateProvider.notifier).previous(),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      switch (selectedDateRangeFilter) {
                        DateRangeFilter.yearly => 'Tahunan',
                        DateRangeFilter.monthly => 'Bulanan',
                        DateRangeFilter.daily => 'Harian',
                      },
                      style: context.textTheme.titleMedium,
                    ),
                    _dateRangeFilterSubtitle(),
                  ],
                ),
              ),
              IconButton.outlined(
                onPressed: () =>
                    ref.read(selectedChartDateProvider.notifier).next(),
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
            child: ref.watch(chartDataProvider).maybeWhen(
                  loading: () => const LoadingContainer(),
                  data: (r) => BarChart(
                    BarChartData(
                      barTouchData: BarTouchData(
                        enabled: true,
                        handleBuiltInTouches: true,
                        touchTooltipData: BarTouchTooltipData(
                          tooltipPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          tooltipBgColor: context.colorScheme.surfaceVariant,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                              BarTooltipItem(
                            NumberFormat.currency().format(rod.toY),
                            context.textTheme.bodySmall ?? const TextStyle(),
                          ),
                        ),
                        touchCallback: (event, response) {
                          if (event is FlPanDownEvent) {
                            final groupIndex =
                                response?.spot?.touchedBarGroupIndex;
                            if (groupIndex != null) {
                              ref
                                  .read(
                                      selectedChartDetailDateProvider.notifier)
                                  .change(dateTime: r[groupIndex].dateTime);
                            }
                          }
                        },
                      ),
                      gridData: const FlGridData(
                        drawVerticalLine: false,
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(),
                        rightTitles: const AxisTitles(),
                        leftTitles: const AxisTitles(),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) => Text(
                              switch (selectedDateRangeFilter) {
                                DateRangeFilter.daily => DateFormat.E()
                                    .format(r[value.toInt()].dateTime),
                                DateRangeFilter.monthly => DateFormat.MMM()
                                    .format(r[value.toInt()].dateTime),
                                DateRangeFilter.yearly => DateFormat.y()
                                    .format(r[value.toInt()].dateTime),
                              }
                                  .toLowerCase(),
                              style: context.textTheme.bodySmall,
                            ),
                          ),
                        ),
                      ),
                      barGroups: List.generate(
                        r.length,
                        (index) {
                          final chartData = r[index];

                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: chartData.totalIncome,
                                width: 16,
                                borderRadius: BorderRadius.circular(4),
                                color: context.colorScheme.primary,
                              ),
                              BarChartRodData(
                                toY: chartData.totalExpense,
                                width: 16,
                                borderRadius: BorderRadius.circular(4),
                                color: context.colorScheme.primaryContainer,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  orElse: () => const EmptyContainer(),
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
      ],
    );
  }

  Widget _dateRangeFilterSubtitle() {
    return HookConsumer(
      builder: (context, ref, child) {
        final selectedDateRangeFilter =
            ref.watch(selectedDateRangeFilterProvider);

        String start = '', end = '';
        final firstDate = ref.read(selectedFirstChartDateProvider);
        final lastDate = ref.read(selectedLastChartDateProvider);

        switch (selectedDateRangeFilter) {
          case DateRangeFilter.yearly:
            start = DateFormat.y().format(firstDate);
            end = DateFormat.y().format(lastDate);
          case DateRangeFilter.monthly:
            start = DateFormat.yMMM().format(firstDate);
            end = DateFormat.yMMM().format(lastDate);
          case DateRangeFilter.daily:
            start = DateFormat.yMMMd().format(firstDate);
            end = DateFormat.yMMMd().format(lastDate);
        }

        return Text(
          '$start - $end',
          style: context.textTheme.bodySmall,
        );
      },
    );
  }
}
