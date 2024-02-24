import '../../core/enums/transaction_range_filter.dart';

class TransactionRangeFilterItem {
  final String title;
  final DateRangeFilter transactionRangeFilter;

  TransactionRangeFilterItem({
    required this.title,
    required this.transactionRangeFilter,
  });
}
