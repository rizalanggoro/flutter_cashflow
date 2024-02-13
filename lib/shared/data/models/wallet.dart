import 'package:cashflow/shared/data/models/category.dart';
import 'package:cashflow/shared/data/models/transaction.dart';
import 'package:isar/isar.dart';

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
