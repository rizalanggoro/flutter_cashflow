import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/sources/preferences.dart';

const _prefCurrentWalletSummaryCardVisible = 'currentWalletSummaryCardVisible';
const _prefAllWalletsSummaryCardVisible = 'allWalletsSummaryCardVisible';

class PreferenceData {
  final bool currentWalletSummaryCardVisible, allWalletsSummaryCardVisible;

  PreferenceData({
    required this.currentWalletSummaryCardVisible,
    required this.allWalletsSummaryCardVisible,
  });

  PreferenceData copyWith({
    bool? currentWalletSummaryCardVisible,
    bool? allWalletsSummaryCardVisible,
  }) =>
      PreferenceData(
        currentWalletSummaryCardVisible: currentWalletSummaryCardVisible ??
            this.currentWalletSummaryCardVisible,
        allWalletsSummaryCardVisible:
            allWalletsSummaryCardVisible ?? this.allWalletsSummaryCardVisible,
      );
}

class PreferencesNotifier extends Notifier<PreferenceData> {
  @override
  PreferenceData build() {
    final preferences = ref.watch(preferencesSourceProvider).instance;

    return PreferenceData(
      currentWalletSummaryCardVisible:
          preferences.getBool(_prefCurrentWalletSummaryCardVisible) ?? true,
      allWalletsSummaryCardVisible:
          preferences.getBool(_prefAllWalletsSummaryCardVisible) ?? true,
    );
  }

  void toggleCurrentWalletSummaryCardVisibility() async {
    final newValue = !state.currentWalletSummaryCardVisible;
    ref
        .read(preferencesSourceProvider)
        .instance
        .setBool(_prefCurrentWalletSummaryCardVisible, newValue)
        .then(
          (value) => state = state.copyWith(
            currentWalletSummaryCardVisible: newValue,
          ),
        );
  }

  void toggleAllWalletsSummaryCardVisibility() async {
    final newValue = !state.allWalletsSummaryCardVisible;
    ref
        .read(preferencesSourceProvider)
        .instance
        .setBool(_prefAllWalletsSummaryCardVisible, newValue)
        .then(
          (value) => state = state.copyWith(
            allWalletsSummaryCardVisible: newValue,
          ),
        );
  }
}

final preferencesProvider =
    NotifierProvider<PreferencesNotifier, PreferenceData>(
        PreferencesNotifier.new);
