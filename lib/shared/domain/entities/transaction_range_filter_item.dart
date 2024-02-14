import '../../enums/transaction_range_filter.dart';

class TransactionRangeFilterItem {
  final String title;
  final TransactionRangeFilter transactionRangeFilter;

  TransactionRangeFilterItem({
    required this.title,
    required this.transactionRangeFilter,
  });
}
