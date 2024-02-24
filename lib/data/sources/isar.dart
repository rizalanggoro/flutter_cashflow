import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../shared/data/models/category.dart';
import '../../shared/data/models/transaction.dart';
import '../../shared/data/models/wallet.dart';

class IsarSource {
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
final isarSourceProvider = Provider<IsarSource>(
  (ref) => IsarSource(),
);
