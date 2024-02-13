import 'package:cashflow/shared/data/models/transaction.dart';
import 'package:cashflow/shared/data/models/wallet.dart';
import 'package:cashflow/shared/enums/category_type.dart';
import 'package:isar/isar.dart';

part 'category.g.dart';

@collection
@Name('categories')
class CategoryModel {
  Id id = Isar.autoIncrement;

  late String name;
  @Enumerated(EnumType.name)
  late CategoryType type;
  late DateTime createdAt;
  late DateTime updatedAt;

  @Backlink(to: 'categories')
  final wallet = IsarLink<WalletModel>();
  final transactions = IsarLinks<TransactionModel>();
}
