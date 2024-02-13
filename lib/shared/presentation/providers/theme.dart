import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/providers/preferences.dart';

const _prefKey = 'isDarkMode';

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final isDarkMode =
        ref.watch(preferencesProvider).instance.getBool(_prefKey) ?? false;

    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  void change({required ThemeMode themeMode}) async {
    ref
        .read(preferencesProvider)
        .instance
        .setBool(_prefKey, themeMode == ThemeMode.dark)
        .then((value) {
      if (value) {
        state = themeMode;
      }
    });
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);
