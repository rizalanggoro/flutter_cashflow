import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/sources/preferences.dart';

const _prefCurrentWalletSummaryCardVisible = 'currentWalletSummaryCardVisible';
const _prefAllWalletsSummaryCardVisible = 'allWalletsSummaryCardVisible';
const _prefDarkThemeEnable = 'theme';

class PreferenceData {
  final bool currentWalletSummaryCardVisible,
      allWalletsSummaryCardVisible,
      darkThemeEnable;

  PreferenceData({
    required this.currentWalletSummaryCardVisible,
    required this.allWalletsSummaryCardVisible,
    required this.darkThemeEnable,
  });

  PreferenceData copyWith({
    bool? currentWalletSummaryCardVisible,
    bool? allWalletsSummaryCardVisible,
    bool? darkThemeEnable,
  }) =>
      PreferenceData(
        currentWalletSummaryCardVisible: currentWalletSummaryCardVisible ??
            this.currentWalletSummaryCardVisible,
        allWalletsSummaryCardVisible:
            allWalletsSummaryCardVisible ?? this.allWalletsSummaryCardVisible,
        darkThemeEnable: darkThemeEnable ?? this.darkThemeEnable,
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
      darkThemeEnable: preferences.getBool(_prefDarkThemeEnable) ?? false,
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

  void toggleDarkTheme() async {
    final newValue = !state.darkThemeEnable;
    ref
        .read(preferencesSourceProvider)
        .instance
        .setBool(_prefDarkThemeEnable, newValue)
        .then(
          (value) => state = state.copyWith(
            darkThemeEnable: newValue,
          ),
        );
  }
}

final preferencesProvider =
    NotifierProvider<PreferencesNotifier, PreferenceData>(
        PreferencesNotifier.new);
