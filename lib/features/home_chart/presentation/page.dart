import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/chart_detail_view.dart';
import 'widgets/chart_view.dart';

@RoutePage()
class HomeChartPage extends HookConsumerWidget {
  const HomeChartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('build: home chart page');

    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChartView(),
          Gap(8),
          ChartDetailView(),

          // spacer
          Gap(56 + 32),
        ],
      ),
    );
  }
}
