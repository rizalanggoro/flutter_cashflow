import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/enums/category_type.dart';
import '../../../core/router/router.gr.dart';
import '../../../core/utils/extensions.dart';
import '../../../domain/usecases/delete_transaction_by_id.dart';
import '../../../domain/usecases/read_transaction_by_id.dart';
import '../../../domain/usecases/watch_transaction_by_id.dart';
import '../../widgets/empty_container.dart';
import '../../widgets/failure_container.dart';
import '../../widgets/loading_container.dart';

@RoutePage()
class DetailTransactionPage extends HookConsumerWidget {
  final int transactionId;

  const DetailTransactionPage({
    super.key,
    required this.transactionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionSnapshot = useFuture(
      useMemoized(
        () => ref
            .watch(readTransactionByIdUseCaseProvider)
            .call(transactionId: transactionId),
        [
          useStream(ref
              .watch(watchTransactionByIdUseCaseProvider)
              .call(transactionId: transactionId)
              .fold((l) => null, (r) => r))
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Transaksi'),
        actions: [
          IconButton(
            onPressed: () => context.router.push(
              WriteTransactionRoute(
                transactionId: transactionId,
              ),
            ),
            icon: const Icon(Icons.edit_rounded),
          ),
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Hapus transaksi'),
                content: const Text(
                  'Apakah Anda yakin akan menghapus transaksi ini?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => context.router.pop(),
                    child: const Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () => ref
                        .read(deleteTransactionByIdUseCaseProvider)
                        .call(transactionId: transactionId)
                        .then(
                          (value) => value.fold(
                            (l) => context.showSnackBar(message: l.message),
                            (r) => context.router.popUntil(
                              (route) => route.settings.name == 'HomeRoute',
                            ),
                          ),
                        ),
                    child: const Text('Hapus'),
                  ),
                ],
              ),
            ),
            icon: const Icon(Icons.delete_rounded),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: switch (transactionSnapshot.connectionState) {
        ConnectionState.waiting => const LoadingContainer(),
        ConnectionState.done => transactionSnapshot.data?.fold(
              (l) => FailureContainer(message: l.message),
              (r) => SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                      ),
                      child: Text(
                        NumberFormat.currency().format(r.amount),
                        style: context.textTheme.headlineSmall,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                      ),
                      child: Text(
                        'Catatan',
                        style: context.textTheme.titleMedium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                      ),
                      child: Text(r.note),
                    ),

                    // others
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 8,
                        bottom: 8,
                      ),
                      child: Text(
                        'Rincian transaksi',
                        style: context.textTheme.titleMedium,
                      ),
                    ),
                    ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.wallet_rounded),
                      ),
                      title: const Text('Dompet'),
                      subtitle: Text(
                        r.wallet.value?.name ?? 'Tidak ada dompet',
                      ),
                    ),
                    Builder(builder: (context) {
                      final category = r.category.value;
                      final categoryType = category?.type;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              (categoryType ?? CategoryType.income).isExpense
                                  ? context.colorScheme.errorContainer
                                  : context.colorScheme.primaryContainer,
                          foregroundColor:
                              (categoryType ?? CategoryType.income).isExpense
                                  ? context.colorScheme.onErrorContainer
                                  : context.colorScheme.onPrimaryContainer,
                          child: Icon(
                            categoryType == null
                                ? Icons.remove_rounded
                                : (categoryType.isIncome
                                    ? Icons.south_west_rounded
                                    : Icons.north_east_rounded),
                          ),
                        ),
                        title: const Text('Kategori'),
                        subtitle: Text(
                          r.category.value?.name ?? 'Tidak ada kategori',
                        ),
                      );
                    }),
                    ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.today_rounded),
                      ),
                      title: const Text('Tanggal'),
                      subtitle: Text(
                        DateFormat.yMMMMEEEEd().format(r.date),
                      ),
                    ),
                  ],
                ),
              ),
            ) ??
            const EmptyContainer(),
        _ => const EmptyContainer(),
      },
    );
  }
}
