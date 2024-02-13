import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'core/application/application.dart';
import 'shared/data/providers/isar.dart';
import 'shared/data/providers/preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'id';
  initializeDateFormatting();

  final isar = IsarProvider();
  await isar.initialize();

  final preferences = PreferencesProvider();
  await preferences.initialize();

  // await isar.instance.writeTxn(() => isar.instance.clear());

  runApp(
    ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(isar),
        preferencesProvider.overrideWithValue(preferences),
      ],
      child: const MyApplication(),
    ),
  );
}
