import 'package:isar/isar.dart';

import '../../core/enums/category_type.dart';
import 'transaction.dart';
import 'wallet.dart';

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
