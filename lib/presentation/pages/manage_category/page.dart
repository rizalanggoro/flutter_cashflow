import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/enums/category_type.dart';
import '../../../core/failure/failure.dart';
import '../../../core/router/router.gr.dart';
import '../../../data/models/category.dart';
import '../../providers/expense_categories.dart';
import '../../providers/income_categories.dart';
import '../../widgets/empty_container.dart';
import '../../widgets/failure_container.dart';
import '../../widgets/loading_container.dart';
import 'widgets/bottom_sheet_confirm_delete_category.dart';

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
        onPressed: () => context.router.push(
          const WriteCategoryRoute(),
        ),
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
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Icon(
                              categoryType.isIncome
                                  ? Icons.south_west_rounded
                                  : Icons.north_east_rounded,
                            ),
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
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                child: ListTile(
                                  leading: Icon(Icons.edit_rounded),
                                  title: Text('Ubah kategori'),
                                ),
                              ),
                              PopupMenuItem(
                                onTap: () => showModalBottomSheet(
                                  context: context,
                                  showDragHandle: true,
                                  useSafeArea: true,
                                  isScrollControlled: true,
                                  builder: (context) =>
                                      BottomSheetConfirmDeleteCategory(
                                    category: category,
                                  ),
                                ),
                                child: const ListTile(
                                  leading: Icon(Icons.delete_rounded),
                                  title: Text('Hapus kategori'),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: data.length,
                    ),
              orElse: () => const EmptyContainer(),
            ),
      );
}
