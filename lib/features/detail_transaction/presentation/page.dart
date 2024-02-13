import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/extensions.dart';
import '../../../shared/presentation/widgets/empty_container.dart';
import '../../../shared/presentation/widgets/failure_container.dart';
import '../../../shared/presentation/widgets/loading_container.dart';
import '../domain/usecases/read_transaction.dart';

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
            .watch(readTransactionUseCaseProvider)
            .call(transactionId: transactionId),
        [],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Transaksi'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_rounded),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete_rounded),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: switch (transactionSnapshot.connectionState) {
        ConnectionState.waiting => const LoadingContainer(),
        ConnectionState.done => transactionSnapshot.data?.fold(
              (l) => FailureContainer(message: l.message),
              (r) => r == null
                  ? const EmptyContainer()
                  : SingleChildScrollView(
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
                          ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.category_rounded),
                            ),
                            title: const Text('Kategori'),
                            subtitle: Text(
                              r.category.value?.name ?? 'Tidak ada kategori',
                            ),
                          ),
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
