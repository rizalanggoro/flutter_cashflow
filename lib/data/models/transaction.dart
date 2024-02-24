import 'package:isar/isar.dart';

import 'category.dart';
import 'wallet.dart';

part 'transaction.g.dart';

@collection
@Name('transactions')
class TransactionModel {
  Id id = Isar.autoIncrement;

  late double amount;
  late String note;
  late DateTime date;

  late DateTime createdAt;
  late DateTime updatedAt;

  // links
  @Backlink(to: 'transactions')
  final category = IsarLink<CategoryModel>();
  @Backlink(to: 'transactions')
  final wallet = IsarLink<WalletModel>();
}
