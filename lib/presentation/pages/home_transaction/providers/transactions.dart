import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../core/enums/transaction_range_filter.dart';
import '../../../../core/failure/failure.dart';
import '../../../../data/models/transaction.dart';
import '../../../../data/models/wallet.dart';
import '../../../../data/sources/isar.dart';
import '../../../providers/selected_date_range_filter.dart';
import '../../../providers/selected_wallet.dart';
import 'selected_transaction_date.dart';

class TransactionsNotifier extends AsyncNotifier<List<TransactionModel>> {
  @override
  FutureOr<List<TransactionModel>> build() async {
    final walletId = ref.watch(selectedWalletProvider).value?.id;
    if (walletId == null) {
      throw Failure(message: 'Tidak ada dompet dipilih!');
    }

    final dateRange = ref.watch(selectedDateRangeFilterProvider);
    final date = ref.watch(selectedTransactionDateProvider);

    _listenStream(
      walletId: walletId,
      dateRange: dateRange,
      date: date,
    );

    return _read(
      walletId: walletId,
      dateRange: dateRange,
      date: date,
    );
  }

  void _listenStream({
    required int walletId,
    required DateRangeFilter dateRange,
    required SelectedTransactionDate date,
  }) {
    StreamSubscription subscription = ref
        .watch(isarSourceProvider)
        .instance
        .transactionModels
        .filter()
        .wallet((q) => q.idEqualTo(walletId))
        .optional(
          dateRange.isYearly,
          (q) => q.dateBetween(
            DateTime(date.yearly.year),
            DateTime(date.yearly.year + 1),
            includeLower: true,
            includeUpper: false,
          ),
        )
        .optional(
          dateRange.isMonthly,
          (q) => q.dateBetween(
            DateTime(
              date.monthly.year,
              date.monthly.month,
            ),
            DateTime(
              date.monthly.year,
              date.monthly.month + 1,
            ),
            includeLower: true,
            includeUpper: false,
          ),
        )
        .optional(
          dateRange.isDaily,
          (q) => q.dateBetween(
            DateTime(
              date.daily.year,
              date.daily.month,
              date.daily.day,
            ),
            DateTime(
              date.daily.year,
              date.daily.month,
              date.daily.day + 1,
            ),
            includeLower: true,
            includeUpper: false,
          ),
        )
        .watchLazy()
        .listen((event) async {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(
        () => _read(
          walletId: walletId,
          dateRange: dateRange,
          date: date,
        ),
      );
    });

    ref.onDispose(() => subscription.cancel());
  }

  Future<List<TransactionModel>> _read({
    required int walletId,
    required DateRangeFilter dateRange,
    required SelectedTransactionDate date,
  }) async {
    final result = await ref
        .watch(isarSourceProvider)
        .instance
        .transactionModels
        .filter()
        .wallet((q) => q.idEqualTo(walletId))
        .optional(
          dateRange.isYearly,
          (q) => q.dateBetween(
            DateTime(date.yearly.year),
            DateTime(date.yearly.year + 1),
            includeLower: true,
            includeUpper: false,
          ),
        )
        .optional(
          dateRange.isMonthly,
          (q) => q.dateBetween(
            DateTime(
              date.monthly.year,
              date.monthly.month,
            ),
            DateTime(
              date.monthly.year,
              date.monthly.month + 1,
            ),
            includeLower: true,
            includeUpper: false,
          ),
        )
        .optional(
          dateRange.isDaily,
          (q) => q.dateBetween(
            DateTime(
              date.daily.year,
              date.daily.month,
              date.daily.day,
            ),
            DateTime(
              date.daily.year,
              date.daily.month,
              date.daily.day + 1,
            ),
            includeLower: true,
            includeUpper: false,
          ),
        )
        .sortByDateDesc()
        .findAll();

    return result;
  }
}

final transactionsProvider =
    AsyncNotifierProvider<TransactionsNotifier, List<TransactionModel>>(
        TransactionsNotifier.new);
