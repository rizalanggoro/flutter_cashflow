import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../data/sources/preferences.dart';

const _prefKey = 'homeDashboardBalanceVisibility';

class BalanceVisibilityNotifier extends Notifier<bool> {
  @override
  bool build() =>
      ref.watch(preferencesSourceProvider).instance.getBool(_prefKey) ?? true;

  void toggle() => ref
      .read(preferencesSourceProvider)
      .instance
      .setBool(_prefKey, !state)
      .then((value) => state = !state);
}

final balanceVisibilityProvider =
    NotifierProvider<BalanceVisibilityNotifier, bool>(
  BalanceVisibilityNotifier.new,
);
