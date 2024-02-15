import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'providers/selected_chart_detail_date.dart';
import 'widgets/chart_detail_view.dart';
import 'widgets/chart_view.dart';

@RoutePage()
class HomeChartPage extends HookConsumerWidget {
  const HomeChartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('build: home chart page');

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ChartView(),
          const Gap(16),

          Consumer(
            builder: (context, ref, child) {
              return switch (ref.watch(selectedChartDetailDateProvider)) {
                DateTime() => const Column(
                    children: [
                      Divider(),
                      ChartDetailView(),
                    ],
                  ),
                null => Container(),
              };
            },
          ),

          // spacer
          const Gap(56 + 32),
        ],
      ),
    );
  }
}
