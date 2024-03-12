import 'package:freezed_annotation/freezed_annotation.dart';

part 'preference.freezed.dart';

@freezed
class Preference with _$Preference {
  // dashboard
  static const dashboardShowCurrentWalletCardKey =
      'dashboardShowCurrentWalletCard';
  static const dashboardShowAllWalletsCardKey = 'dashboardShowAllWalletsCard';

  // appearance
  static const appearanceUseSystemThemeKey = 'appearanceUseSystemTheme';
  static const appearanceUseDarkModeKey = 'appearanceUseDarkMode';
  static const appearanceUseTrueDarkKey = 'appearanceUseTrueDark';
  static const appearanceColorSchemeNameKey = 'appearanceColorSchemeName';

  const factory Preference({
    // dashboard
    required bool dashboardShowCurrentWalletCard,
    required bool dashboardShowAllWalletsCard,

    // appearance
    required bool appearanceUseSystemTheme,
    required bool appearanceUseDarkMode,
    required bool appearanceUseTrueDark,
    required String appearanceColorSchemeName,
  }) = _Preference;
}
