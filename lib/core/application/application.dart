import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../presentation/providers/theme.dart';
import '../router/router.dart';

MyRouter? _router;

class MyApplication extends ConsumerWidget {
  const MyApplication({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _router ??= MyRouter(ref: ref);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router?.config(),
      theme: ThemeData(
        useMaterial3: true,
        brightness: ref.watch(themeProvider) == ThemeMode.dark
            ? Brightness.dark
            : Brightness.light,
        colorSchemeSeed: const Color(0xff164863),
      ).copyWith(
        // app bar
        appBarTheme: const AppBarTheme(
          scrolledUnderElevation: 0,
        ),

        // input
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
        ),
      ),
    );
  }
}
