import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/sources/preferences.dart';
import '../models/preference.dart';

class PreferencesNotifier extends Notifier<Preference> {
  @override
  Preference build() {
    final preferences = ref.watch(preferencesSourceProvider).instance;

    return Preference(
      // dashboard
      dashboardShowCurrentWalletCard:
          preferences.getBool(Preference.dashboardShowCurrentWalletCardKey) ??
              true,
      dashboardShowAllWalletsCard:
          preferences.getBool(Preference.dashboardShowAllWalletsCardKey) ??
              true,

      // appearance
      appearanceUseSystemTheme:
          preferences.getBool(Preference.appearanceUseSystemThemeKey) ?? true,
      appearanceUseDarkMode:
          preferences.getBool(Preference.appearanceUseDarkModeKey) ?? false,
      appearanceUseTrueDark:
          preferences.getBool(Preference.appearanceUseTrueDarkKey) ?? false,
      appearanceColorSchemeName:
          preferences.getString(Preference.appearanceColorSchemeNameKey) ??
              FlexScheme.dellGenoa.name,
    );
  }

  void toggleCurrentWalletSummaryCardVisibility() async {
    final newValue = !state.dashboardShowCurrentWalletCard;
    ref
        .read(preferencesSourceProvider)
        .instance
        .setBool(Preference.dashboardShowCurrentWalletCardKey, newValue)
        .then(
          (value) => state = state.copyWith(
            dashboardShowCurrentWalletCard: newValue,
          ),
        );
  }

  void toggleAllWalletsSummaryCardVisibility() async {
    final newValue = !state.dashboardShowAllWalletsCard;
    ref
        .read(preferencesSourceProvider)
        .instance
        .setBool(Preference.dashboardShowAllWalletsCardKey, newValue)
        .then(
          (value) => state = state.copyWith(
            dashboardShowAllWalletsCard: newValue,
          ),
        );
  }

  void toggleAppearanceUseSystemTheme() async {
    final newValue = !state.appearanceUseSystemTheme;
    ref
        .read(preferencesSourceProvider)
        .instance
        .setBool(Preference.appearanceUseSystemThemeKey, newValue)
        .then(
          (value) => state = state.copyWith(
            appearanceUseSystemTheme: newValue,
          ),
        );
  }

  void toggleAppearanceUseDarkMode() async {
    final newValue = !state.appearanceUseDarkMode;
    ref
        .read(preferencesSourceProvider)
        .instance
        .setBool(Preference.appearanceUseDarkModeKey, newValue)
        .then(
          (value) => state = state.copyWith(
            appearanceUseDarkMode: newValue,
          ),
        );
  }

  void toggleAppearanceUseTrueDark() async {
    final newValue = !state.appearanceUseTrueDark;
    ref
        .read(preferencesSourceProvider)
        .instance
        .setBool(Preference.appearanceUseTrueDarkKey, newValue)
        .then(
          (value) => state = state.copyWith(
            appearanceUseTrueDark: newValue,
          ),
        );
  }

  void updateAppearanceColorScheme({
    required String colorSchemeName,
  }) async =>
      ref
          .read(preferencesSourceProvider)
          .instance
          .setString(Preference.appearanceColorSchemeNameKey, colorSchemeName)
          .then(
            (value) => state = state.copyWith(
              appearanceColorSchemeName: colorSchemeName,
            ),
          );
}

final preferencesProvider =
    NotifierProvider<PreferencesNotifier, Preference>(PreferencesNotifier.new);
