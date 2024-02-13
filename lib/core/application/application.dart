import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared/presentation/providers/theme.dart';
import '../router/router.dart';

MyRouter? _router;

class MyApplication extends ConsumerWidget {
  const MyApplication({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _router ??= MyRouter(ref: ref);

    final themeData = ThemeData(
      useMaterial3: true,
      brightness: ref.watch(themeProvider) == ThemeMode.dark
          ? Brightness.dark
          : Brightness.light,
      colorSchemeSeed: const Color(0xff164863),
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router?.config(),
      theme: themeData.copyWith(
        // app bar
        appBarTheme: const AppBarTheme(
          scrolledUnderElevation: 0,
        ),

        // input
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
        ),
        // inputDecorationTheme: InputDecorationTheme(
        //   contentPadding: Constants.inputPadding,
        //   enabledBorder: OutlineInputBorder(
        //     borderRadius: BorderRadius.all(Constants.inputRadius),
        //     borderSide: BorderSide(
        //       width: Constants.inputBorderWidth,
        //       color: themeData.colorScheme.outline.withOpacity(.32),
        //     ),
        //   ),
        //   focusedBorder: OutlineInputBorder(
        //     borderRadius: BorderRadius.all(Constants.inputRadius),
        //     borderSide: BorderSide(
        //       width: Constants.inputBorderWidth,
        //       color: themeData.colorScheme.primary,
        //     ),
        //   ),
        // ),

        // segmented button
        // segmentedButtonTheme: SegmentedButtonThemeData(
        //   selectedIcon: const Icon(Icons.check_rounded),
        //   style: OutlinedButton.styleFrom(
        //     shape: RoundedRectangleBorder(
        //       // borderRadius: BorderRadius.all(Constants.buttonRadius),
        //       borderRadius: BorderRadius.circular(24),
        //     ),
        //     side: BorderSide(
        //       color: themeData.colorScheme.outline.withOpacity(.32),
        //     ),
        //   ),
        // ),

        // buttons
        // filledButtonTheme: FilledButtonThemeData(
        //   style: FilledButton.styleFrom(
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.all(Constants.buttonRadius),
        //     ),
        //   ),
        // ),
        // outlinedButtonTheme: OutlinedButtonThemeData(
        //   style: OutlinedButton.styleFrom(
        //     side: BorderSide(
        //       color: themeData.colorScheme.outline.withOpacity(.32),
        //     ),
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.all(Constants.buttonRadius),
        //     ),
        //   ),
        // ),

        // fab
        // floatingActionButtonTheme: FloatingActionButtonThemeData(
        //   elevation: 0,
        //   backgroundColor: themeData.colorScheme.primary,
        //   foregroundColor: themeData.colorScheme.onPrimary,
        // ),

        // navigation bar
        // navigationBarTheme: NavigationBarThemeData(
        //   backgroundColor: themeData.colorScheme.background,
        //   surfaceTintColor: themeData.colorScheme.background,
        //   labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        // ),
      ),
    );
  }
}
