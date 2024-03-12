import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../presentation/providers/preferences.dart';
import '../router/router.dart';

MyRouter? _router;

class MyApplication extends ConsumerWidget {
  const MyApplication({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _router ??= MyRouter(ref: ref);

    final colorScheme = FlexScheme.values
        .where((element) =>
            element.name ==
            ref.watch(preferencesProvider
                .select((value) => value.appearanceColorSchemeName)))
        .firstOrNull;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router?.config(),
      themeMode: ref.watch(preferencesProvider.select(
        (value) => value.appearanceUseSystemTheme,
      ))
          ? ThemeMode.system
          : (ref.watch(preferencesProvider.select(
              (value) => value.appearanceUseDarkMode,
            ))
              ? ThemeMode.dark
              : ThemeMode.light),

      // flex color scheme
      theme: FlexThemeData.light(
        scheme: colorScheme,
        subThemesData: const FlexSubThemesData(
          interactionEffects: false,
          tintedDisabledControls: false,
          blendOnColors: false,
          useTextTheme: true,
          inputDecoratorBorderType: FlexInputBorderType.underline,
          inputDecoratorUnfocusedBorderIsColored: false,
          alignedDropdown: true,
          tooltipRadius: 4,
          tooltipSchemeColor: SchemeColor.inverseSurface,
          tooltipOpacity: 0.9,
          useInputDecoratorThemeInDialogs: true,
          snackBarElevation: 6,
          snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
          navigationBarSelectedLabelSchemeColor: SchemeColor.onSurface,
          navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
          navigationBarMutedUnselectedLabel: false,
          navigationBarSelectedIconSchemeColor: SchemeColor.onSurface,
          navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
          navigationBarMutedUnselectedIcon: false,
          navigationBarIndicatorSchemeColor: SchemeColor.secondaryContainer,
          navigationBarIndicatorOpacity: 1.00,
          navigationRailSelectedLabelSchemeColor: SchemeColor.onSurface,
          navigationRailUnselectedLabelSchemeColor: SchemeColor.onSurface,
          navigationRailMutedUnselectedLabel: false,
          navigationRailSelectedIconSchemeColor: SchemeColor.onSurface,
          navigationRailUnselectedIconSchemeColor: SchemeColor.onSurface,
          navigationRailMutedUnselectedIcon: false,
          navigationRailIndicatorSchemeColor: SchemeColor.secondaryContainer,
          navigationRailIndicatorOpacity: 1.00,
          navigationRailBackgroundSchemeColor: SchemeColor.surface,
          navigationRailLabelType: NavigationRailLabelType.none,
          navigationBarElevation: 0,
          appBarScrolledUnderElevation: 0,
        ),
        keyColors: const FlexKeyColors(),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        appBarStyle: FlexAppBarStyle.scaffoldBackground,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: colorScheme,
        subThemesData: const FlexSubThemesData(
          interactionEffects: false,
          tintedDisabledControls: false,
          useTextTheme: true,
          inputDecoratorBorderType: FlexInputBorderType.underline,
          inputDecoratorUnfocusedBorderIsColored: false,
          alignedDropdown: true,
          tooltipRadius: 4,
          tooltipSchemeColor: SchemeColor.inverseSurface,
          tooltipOpacity: 0.9,
          useInputDecoratorThemeInDialogs: true,
          snackBarElevation: 6,
          snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
          navigationBarSelectedLabelSchemeColor: SchemeColor.onSurface,
          navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
          navigationBarMutedUnselectedLabel: false,
          navigationBarSelectedIconSchemeColor: SchemeColor.onSurface,
          navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
          navigationBarMutedUnselectedIcon: false,
          navigationBarIndicatorSchemeColor: SchemeColor.secondaryContainer,
          navigationBarIndicatorOpacity: 1.00,
          navigationRailSelectedLabelSchemeColor: SchemeColor.onSurface,
          navigationRailUnselectedLabelSchemeColor: SchemeColor.onSurface,
          navigationRailMutedUnselectedLabel: false,
          navigationRailSelectedIconSchemeColor: SchemeColor.onSurface,
          navigationRailUnselectedIconSchemeColor: SchemeColor.onSurface,
          navigationRailMutedUnselectedIcon: false,
          navigationRailIndicatorSchemeColor: SchemeColor.secondaryContainer,
          navigationRailIndicatorOpacity: 1.00,
          navigationRailBackgroundSchemeColor: SchemeColor.surface,
          navigationRailLabelType: NavigationRailLabelType.none,
          navigationBarElevation: 0,
          appBarScrolledUnderElevation: 0,
        ),
        keyColors: const FlexKeyColors(),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        darkIsTrueBlack: ref.watch(preferencesProvider.select(
          (value) => value.appearanceUseTrueDark,
        )),
        appBarStyle: FlexAppBarStyle.scaffoldBackground,
      ),
    );
  }
}
