import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'core/application/application.dart';
import 'data/sources/isar.dart';
import 'data/sources/preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'id';
  initializeDateFormatting();

  final isar = IsarSource();
  await isar.initialize();

  final preferences = PreferencesSource();
  await preferences.initialize();

  // await isar.instance.writeTxn(() => isar.instance.clear());

  runApp(
    ProviderScope(
      // observers: [MyRiverpodObserver()],
      overrides: [
        isarSourceProvider.overrideWithValue(isar),
        preferencesSourceProvider.overrideWithValue(preferences),
      ],
      child: const MyApplication(),
    ),
  );
}
