import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class HomeChartPage extends HookConsumerWidget {
  const HomeChartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 3 / 2,
            child: PieChart(
              PieChartData(
                sections: [
                  // income
                  PieChartSectionData(
                    value: 10,
                  ),

                  // expense
                  PieChartSectionData(
                    value: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
