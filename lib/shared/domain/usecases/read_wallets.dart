import 'package:dartz/dartz.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/failure/failure.dart';
import '../../../core/utils/typedefs.dart';
import '../../data/models/wallet.dart';
import '../../data/providers/isar.dart';

class _UseCase {
  final Isar _isar;

  _UseCase({required Isar isar}) : _isar = isar;

  FutureUseCase<List<WalletModel>> call() async {
    try {
      final wallets = await _isar.walletModels.where().sortByName().findAll();
      return Right(wallets);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}

// provider
final readWalletsUseCaseProvider = Provider<_UseCase>((ref) {
  return _UseCase(isar: ref.watch(isarProvider).instance);
});
