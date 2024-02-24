import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/enums/category_type.dart';
import '../../data/models/category.dart';
import '../../domain/usecases/read_categories.dart';
import '../../domain/usecases/watch_categories.dart';
import 'selected_wallet.dart';

class IncomeCategoriesNotifier extends AsyncNotifier<List<CategoryModel>> {
  @override
  Future<List<CategoryModel>> build() async {
    final result = await ref.watch(readCategoriesUseCaseProvider).call(
          walletId: ref.watch(selectedWalletProvider).value?.id,
          categoryType: CategoryType.income,
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
          categoryType: CategoryType.income,
        );

    watchResult.fold(
      (l) => null,
      (r) => subscription = r.listen((event) async {
        state = const AsyncValue.loading();

        final result = await ref.watch(readCategoriesUseCaseProvider).call(
              walletId: ref.watch(selectedWalletProvider).value?.id,
              categoryType: CategoryType.income,
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
final incomeCategoriesProvider =
    AsyncNotifierProvider<IncomeCategoriesNotifier, List<CategoryModel>>(
  IncomeCategoriesNotifier.new,
);
