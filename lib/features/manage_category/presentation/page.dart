import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/failure/failure.dart';
import '../../../core/router/router.gr.dart';
import '../../../shared/data/models/category.dart';
import '../../../shared/enums/category_type.dart';
import '../../../shared/presentation/providers/expense_categories.dart';
import '../../../shared/presentation/providers/income_categories.dart';
import '../../../shared/presentation/widgets/empty_container.dart';
import '../../../shared/presentation/widgets/failure_container.dart';
import '../../../shared/presentation/widgets/loading_container.dart';

// page
@RoutePage()
class ManageCategoryPage extends HookConsumerWidget {
  const ManageCategoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('build: manage category');

    final tabController = useTabController(
      initialLength: 2,
      initialIndex: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori'),
        actions: [
          IconButton(
            onPressed: () => context.pushRoute(
              const SelectWalletRoute(),
            ),
            icon: const Icon(Icons.wallet_rounded),
          ),
          const Gap(16),
        ],
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: 'Pemasukan'),
            Tab(text: 'Pengeluaran'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.router.push(const WriteCategoryRoute()),
        child: const Icon(Icons.add_rounded),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          // income
          _tabBarViewItem(incomeCategoriesProvider),

          // expense
          _tabBarViewItem(expenseCategoriesProvider),
        ],
      ),
    );
  }

  Widget _tabBarViewItem(
    AsyncNotifierProvider<dynamic, List<CategoryModel>> provider,
  ) =>
      HookConsumer(
        builder: (context, ref, child) => ref.watch(provider).maybeWhen(
              loading: () => const LoadingContainer(),
              error: (error, stackTrace) => FailureContainer(
                message: error is Failure ? error.message : error.toString(),
              ),
              data: (data) => data.isEmpty
                  ? const EmptyContainer()
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 56 + 32),
                      itemBuilder: (context, index) {
                        final category = data[index];
                        final categoryType = category.type;

                        return ListTile(
                          leading: Icon(
                            categoryType.isIncome
                                ? Icons.south_west_rounded
                                : Icons.north_east_rounded,
                          ),
                          title: Text(category.name),
                          subtitle: FutureBuilder(
                            future: category.transactions.count(),
                            builder: (context, snapshot) {
                              final count = snapshot.data ?? 0;

                              return Text(Intl.plural(
                                count,
                                zero: 'Tidak ada transaksi',
                                other: '$count transaksi',
                              ));
                            },
                          ),
                          trailing: IconButton(
                            onPressed: () => {},
                            icon: const Icon(Icons.more_vert_rounded),
                          ),
                        );
                      },
                      itemCount: data.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
              orElse: () => const EmptyContainer(),
            ),
      );
}
