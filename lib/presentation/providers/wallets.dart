import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/wallet.dart';
import '../../domain/usecases/read_wallets.dart';
import '../../domain/usecases/watch_wallets.dart';

class WalletsNotifier extends AsyncNotifier<List<WalletModel>> {
  @override
  Future<List<WalletModel>> build() async {
    final result = await ref.watch(readWalletsUseCaseProvider).call();

    _initStreamSubscription();

    return result.fold(
      (l) => throw l,
      (r) => r,
    );
  }

  void _initStreamSubscription() {
    StreamSubscription? subscription;

    final watchResult = ref.watch(watchWalletsUseCaseProvider).call();
    watchResult.fold(
      (l) => null,
      (r) => subscription = r.listen(
        (event) async {
          state = const AsyncValue.loading();

          final result = await ref.watch(readWalletsUseCaseProvider).call();

          state = result.fold(
            (l) => throw l,
            (r) => AsyncValue.data(r),
          );
        },
      ),
    );

    ref.onDispose(() => subscription?.cancel());
  }
}

final walletsProvider =
    AsyncNotifierProvider<WalletsNotifier, List<WalletModel>>(
  WalletsNotifier.new,
);
