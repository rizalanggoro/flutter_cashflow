import 'package:auto_route/auto_route.dart';
import 'package:cashflow/core/utils/extensions.dart';
import 'package:cashflow/shared/presentation/widgets/empty_container.dart';
import 'package:cashflow/shared/presentation/widgets/failure_container.dart';
import 'package:cashflow/shared/presentation/widgets/loading_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/router/router.gr.dart';
import '../../../../shared/constants/constants.dart';
import '../../../../shared/data/models/category.dart';
import '../../../../shared/domain/entities/category_filter_item.dart';
import '../../../../shared/enums/category_filter.dart';
import '../../../../shared/enums/category_type.dart';
import '../../../../shared/presentation/providers/selected_wallet.dart';
import '../../domain/usecases/read_categories.dart';

class BottomSheetSelectCategory extends HookConsumerWidget {
  final CategoryModel? category;

  const BottomSheetSelectCategory({
    super.key,
    this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryFilterItems = [
      CategoryFilterItem(
        title: 'Pemasukan',
        filter: CategoryFilter.income,
      ),
      CategoryFilterItem(
        title: 'Pengeluaran',
        filter: CategoryFilter.expense,
      ),
    ];

    final selectedCategoryFilter = useState<CategoryFilter>(
      (category?.type.isIncome ?? true)
          ? CategoryFilter.income
          : CategoryFilter.expense,
    );
    final selectedCategory = useState(category);

    final snapshotCategories = useFuture(useMemoized(
      () => ref.watch(readCategoriesUseCaseProvider).call(
            walletId: ref.watch(selectedWalletProvider).value?.id,
            filter: selectedCategoryFilter.value,
          ),
      [
        ref.watch(selectedWalletProvider),
        selectedCategoryFilter.value,
      ],
    ));

    return FractionallySizedBox(
      heightFactor: Constants.bottomSheetHeightFactor,
      widthFactor: 1,
      child: Column(
        children: [
          // header
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pilih kategori',
                  style: context.textTheme.titleLarge,
                ),
                IconButton.filledTonal(
                  onPressed: () =>
                      context.router.popAndPush(const ManageCategoryRoute()),
                  icon: const Icon(Icons.add_rounded),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 16,
            ),
            child: SegmentedButton(
              segments: categoryFilterItems
                  .map((e) => ButtonSegment(
                        value: e.filter,
                        label: Text(e.title),
                      ))
                  .toList(),
              selected: {selectedCategoryFilter.value},
              onSelectionChanged: (setValue) =>
                  selectedCategoryFilter.value = setValue.first,
            ),
          ),

          // content
          Expanded(
            child: switch (snapshotCategories.connectionState) {
              ConnectionState.waiting => const LoadingContainer(),
              ConnectionState.done => snapshotCategories.data?.fold(
                    (l) => FailureContainer(message: l.message),
                    (r) => r.isEmpty
                        ? const EmptyContainer()
                        : ListView.builder(
                            itemBuilder: (context, index) {
                              final category = r[index];

                              return RadioListTile(
                                value: category.id,
                                groupValue: selectedCategory.value?.id ?? -1,
                                onChanged: (value) =>
                                    selectedCategory.value = category,
                                title: Text(category.name),
                                secondary: CircleAvatar(
                                  child: Icon(
                                    category.type.isIncome
                                        ? Icons.south_west_rounded
                                        : Icons.north_east_rounded,
                                  ),
                                ),
                              );
                            },
                            itemCount: r.length,
                            shrinkWrap: true,
                          ),
                  ) ??
                  const EmptyContainer(),
              _ => const EmptyContainer(),
            },
          ),

          // actions
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 16,
            ),
            width: double.infinity,
            child: FilledButton(
              onPressed: () => context.router.pop(selectedCategory.value),
              child: const Text('Selesai'),
            ),
          ),
        ],
      ),
    );
  }
}
