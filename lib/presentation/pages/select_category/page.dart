import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/enums/category_type.dart';
import '../../../core/failure/failure.dart';
import '../../../core/router/router.gr.dart';
import '../../../data/models/category.dart';
import '../../providers/expense_categories.dart';
import '../../providers/income_categories.dart';
import '../../widgets/empty_container.dart';
import '../../widgets/failure_container.dart';
import '../../widgets/loading_container.dart';

@RoutePage()
class SelectCategoryPage extends HookConsumerWidget {
  final CategoryModel? initialCategory;

  const SelectCategoryPage({
    super.key,
    this.initialCategory,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(
      initialLength: 2,
      initialIndex: initialCategory == null
          ? 0
          : (initialCategory!.type.isIncome ? 0 : 1),
    );
    final selectedCategory = useState<CategoryModel?>(initialCategory);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Kategori'),
        actions: [
          IconButton(
            onPressed: () => context.router.popAndPush(
              const WriteCategoryRoute(),
            ),
            icon: const Icon(Icons.add_rounded),
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
      body: TabBarView(
        controller: tabController,
        children: [
          // income
          _tabItem(incomeCategoriesProvider, selectedCategory),

          // expense
          _tabItem(expenseCategoriesProvider, selectedCategory),
        ],
      ),
    );
  }

  Widget _tabItem(
    AsyncNotifierProvider provider,
    ValueNotifier<CategoryModel?> selectedCategory,
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
                      itemBuilder: (context, index) {
                        final category = data[index];

                        return RadioListTile(
                          value: category.id,
                          groupValue: selectedCategory.value?.id,
                          onChanged: (value) {
                            selectedCategory.value = category;
                            context.router.pop(category);
                          },
                          title: Text(category.name),
                        );
                      },
                      itemCount: data.length,
                    ),
              orElse: () => const EmptyContainer(),
            ),
      );
}
