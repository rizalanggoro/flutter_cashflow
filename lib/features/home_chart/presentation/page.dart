import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/extensions.dart';
import '../../../shared/enums/transaction_range_filter.dart';
import '../../../shared/presentation/providers/selected_transaction_range_filter.dart';

@RoutePage()
class HomeChartPage extends HookConsumerWidget {
  const HomeChartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // global state
    final selectedTransactionRangeFilter =
        ref.watch(selectedTransactionRangeFilterProvider);

    // local state
    final selectedBarChartIndex = useState(0);
    final dailyDate = useState(DateTime.now());
    final monthlyDate = useState(DateTime.now());
    final yearlyDate = useState(DateTime.now());

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
                  onPressed: () => _onTapChangeDateRange(
                    isAdd: false,
                    transactionRangeFilter: selectedTransactionRangeFilter,
                    dailyDate: dailyDate,
                    monthlyDate: monthlyDate,
                    yearlyDate: yearlyDate,
                  ),
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
                      Builder(builder: (context) {
                        var startDate = '', endDate = '';

                        if (selectedTransactionRangeFilter.isDaily) {
                          final currentWeekday = dailyDate.value.weekday;
                          startDate = DateFormat.yMMMEd().format(
                            dailyDate.value.subtract(
                              Duration(days: currentWeekday - 1),
                            ),
                          );
                          endDate = DateFormat.yMMMEd().format(
                            dailyDate.value.add(
                              Duration(days: 7 - currentWeekday),
                            ),
                          );
                        } else if (selectedTransactionRangeFilter.isMonthly) {
                          final currentDate = monthlyDate.value;
                          startDate = DateFormat.yMMM().format(
                            DateTime(currentDate.year, currentDate.month - 3),
                          );
                          endDate = DateFormat.yMMM().format(
                            currentDate,
                          );
                        } else if (selectedTransactionRangeFilter.isYearly) {
                          final currentDate = yearlyDate.value;
                          startDate = DateFormat.y().format(
                            DateTime(currentDate.year - 2),
                          );
                          endDate = DateFormat.y().format(
                            currentDate,
                          );
                        }

                        return Text(
                          '$startDate - $endDate',
                          style: context.textTheme.bodySmall,
                        );
                      }),
                    ],
                  ),
                ),
                IconButton.outlined(
                  onPressed: () => _onTapChangeDateRange(
                    isAdd: true,
                    transactionRangeFilter: selectedTransactionRangeFilter,
                    dailyDate: dailyDate,
                    monthlyDate: monthlyDate,
                    yearlyDate: yearlyDate,
                  ),
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
                  gridData: const FlGridData(drawVerticalLine: false),
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
                        getTitlesWidget: (value, meta) {
                          var title = '';

                          if (selectedTransactionRangeFilter.isDaily) {
                            final currentDate = dailyDate.value;
                            final currentWeekday = currentDate.weekday;
                            title = DateFormat.E().format(
                              currentDate
                                  .subtract(Duration(days: currentWeekday - 1))
                                  .add(Duration(days: value.toInt())),
                            );
                          } else if (selectedTransactionRangeFilter.isMonthly) {
                            final currentDate = monthlyDate.value;
                            title = DateFormat.MMM().format(
                              DateTime(
                                currentDate.year,
                                currentDate.month - 3 + value.toInt(),
                              ),
                            );
                          } else {
                            final currentDate = yearlyDate.value;
                            title = DateFormat.y().format(
                              DateTime(currentDate.year - 2 + value.toInt()),
                            );
                          }

                          return Text(title);
                        },
                      ),
                    ),
                  ),
                  barGroups: [
                    ...List.generate(
                      selectedTransactionRangeFilter.isDaily
                          ? 7
                          : selectedTransactionRangeFilter.isMonthly
                              ? 4
                              : 3,
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
          const Gap(8),
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
          const Gap(16),

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

          // spacer
          const Gap(56 + 32),
        ],
      ),
    );
  }

  void _onTapChangeDateRange({
    required bool isAdd,
    required TransactionRangeFilter transactionRangeFilter,
    required ValueNotifier<DateTime> dailyDate,
    required ValueNotifier<DateTime> monthlyDate,
    required ValueNotifier<DateTime> yearlyDate,
  }) {
    switch (transactionRangeFilter) {
      case TransactionRangeFilter.daily:
        dailyDate.value = dailyDate.value.add(
          Duration(days: isAdd ? 6 : -6),
        );
        break;

      case TransactionRangeFilter.monthly:
        final currentDate = monthlyDate.value;
        monthlyDate.value = DateTime(
            currentDate.year, currentDate.month + (4 * (isAdd ? 1 : -1)));
        break;

      case TransactionRangeFilter.yearly:
        final currentDate = yearlyDate.value;
        yearlyDate.value = DateTime(currentDate.year + (3 * (isAdd ? 1 : -1)));
        break;
    }
  }
}
