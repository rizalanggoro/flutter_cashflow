import 'package:isar/isar.dart';

import 'category.dart';
import 'transaction.dart';

part 'wallet.g.dart';

@collection
@Name('wallets')
class WalletModel {
  Id id = Isar.autoIncrement;

  late String name;
  late DateTime createdAt;
  late DateTime updatedAt;

  final categories = IsarLinks<CategoryModel>();
  final transactions = IsarLinks<TransactionModel>();
}
