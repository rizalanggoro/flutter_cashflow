import 'package:cashflow/shared/data/models/category.dart';
import 'package:cashflow/shared/data/models/wallet.dart';
import 'package:isar/isar.dart';

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
