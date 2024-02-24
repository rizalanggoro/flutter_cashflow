import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/enums/category_type.dart';
import '../../data/models/category.dart';
import '../../domain/usecases/read_categories.dart';
import '../../domain/usecases/watch_categories.dart';
import 'selected_wallet.dart';

class ExpenseCategoriesNotifier extends AsyncNotifier<List<CategoryModel>> {
  @override
  Future<List<CategoryModel>> build() async {
    final result = await ref.watch(readCategoriesUseCaseProvider).call(
          walletId: ref.watch(selectedWalletProvider).value?.id,
          categoryType: CategoryType.expense,
        );

    // subscribe to stream
    _initStream();

    return result.fold(
      (l) => throw l,
      (r) => r,
    );
  }

  void _initStream() {
    StreamSubscription? subscription;

    final watchResult = ref.watch(watchCategoriesUseCaseProvider).call(
          walletId: ref.watch(selectedWalletProvider).value?.id,
          categoryType: CategoryType.expense,
        );

    watchResult.fold(
      (l) => null,
      (r) => subscription = r.listen((event) async {
        state = const AsyncValue.loading();

        final result = await ref.watch(readCategoriesUseCaseProvider).call(
              walletId: ref.watch(selectedWalletProvider).value?.id,
              categoryType: CategoryType.expense,
            );

        result.fold(
          (l) => throw l,
          (r) => state = AsyncValue.data(r),
        );
      }),
    );

    ref.onDispose(() => subscription?.cancel());
  }
}

// provider
final expenseCategoriesProvider =
    AsyncNotifierProvider<ExpenseCategoriesNotifier, List<CategoryModel>>(
  ExpenseCategoriesNotifier.new,
);
