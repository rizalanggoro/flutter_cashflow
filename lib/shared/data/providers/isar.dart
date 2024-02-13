import 'dart:developer';

import 'package:cashflow/shared/data/models/transaction.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/category.dart';
import '../models/wallet.dart';

class IsarProvider {
  late Isar _isar;

  // getter
  Isar get instance => _isar;

  Future<void> initialize() async {
    final directory = await getApplicationSupportDirectory();
    final path = directory.path;
    log('isar: $path');

    _isar = await Isar.open(
      [
        WalletModelSchema,
        CategoryModelSchema,
        TransactionModelSchema,
      ],
      directory: path,
    );
  }
}

// provider
final isarProvider = Provider<IsarProvider>(
  (ref) => IsarProvider(),
);
