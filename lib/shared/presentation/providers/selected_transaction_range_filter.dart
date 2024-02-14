import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../enums/transaction_range_filter.dart';

final selectedTransactionRangeFilterProvider =
    StateProvider<TransactionRangeFilter>((ref) {
  return TransactionRangeFilter.daily;
});
