import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../data/models/wallet.dart';
import '../../data/sources/isar.dart';
import '../../data/sources/preferences.dart';

// selected wallet
const _prefSelectedWallet = 'selectedWallet';

class SelectedWalletNotifier extends AsyncNotifier<WalletModel?> {
  @override
  Future<WalletModel?> build() async {
    WalletModel? selectedWallet;

    final selectedWalletId = ref
        .watch(preferencesSourceProvider)
        .instance
        .getInt(_prefSelectedWallet);

    // read selected wallet by id
    if (selectedWalletId != null) {
      selectedWallet = await ref
          .watch(isarSourceProvider)
          .instance
          .walletModels
          .get(selectedWalletId);
    }

    // if wallet not found, then read first wallet
    selectedWallet ??= await _readFirstWallet();

    // subscribe to selected wallet
    if (selectedWallet != null) {
      final subscription = ref
          .watch(isarSourceProvider)
          .instance
          .walletModels
          .where()
          .idEqualTo(selectedWallet.id)
          .watchLazy()
          .listen((event) async {
        state = const AsyncValue.loading();
        state = AsyncValue.data(await ref
            .watch(isarSourceProvider)
            .instance
            .walletModels
            .get(selectedWallet!.id));
      });

      // dispose subscription
      ref.onDispose(() => subscription.cancel());
    }

    return selectedWallet;
  }

  Future<WalletModel?> _readFirstWallet() => ref
      .watch(isarSourceProvider)
      .instance
      .walletModels
      .where()
      .sortByName()
      .findFirst();

  Future<void> onDelete() => _readFirstWallet().then(
        (value) => state = AsyncValue.data(value),
      );

  void change({required WalletModel? wallet}) async {
    ref
        .read(preferencesSourceProvider)
        .instance
        .setInt(_prefSelectedWallet, wallet?.id ?? -1)
        .then((value) {
      if (value) {
        state = AsyncValue.data(wallet);
      }
    });
  }
}

final selectedWalletProvider =
    AsyncNotifierProvider<SelectedWalletNotifier, WalletModel?>(
  SelectedWalletNotifier.new,
);
