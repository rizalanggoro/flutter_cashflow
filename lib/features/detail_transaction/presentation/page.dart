import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/extensions.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/presentation/widgets/custom_card.dart';
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
        ConnectionState.waiting => LoadingContainer(),
        ConnectionState.done => transactionSnapshot.data?.fold(
              (l) => FailureContainer(message: l.message),
              (r) => r == null
                  ? EmptyContainer()
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 16,
                          bottom: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              NumberFormat.currency().format(r.amount),
                              style: context.textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Catatan',
                              style: context.textTheme.titleMedium,
                            ),
                            Text(r.note),
                            const SizedBox(height: 16),
                            Text(
                              'Informasi lainnya',
                              style: context.textTheme.titleMedium,
                            ),
                            CustomCard(
                              position: CustomCardPosition.start,
                              margin: const EdgeInsets.only(top: 8),
                              child: ListTile(
                                contentPadding: Constants.listTilePadding,
                                leading: CircleAvatar(
                                  backgroundColor: context.colorScheme.primary,
                                  foregroundColor:
                                      context.colorScheme.onPrimary,
                                  child: const Icon(Icons.wallet_rounded),
                                ),
                                title: const Text('Dompet'),
                                subtitle: Text(
                                  r.wallet.value?.name ?? 'Tidak ada dompet',
                                ),
                              ),
                            ),
                            CustomCard(
                              position: CustomCardPosition.middle,
                              margin: const EdgeInsets.only(top: 2),
                              child: ListTile(
                                contentPadding: Constants.listTilePadding,
                                leading: CircleAvatar(
                                  backgroundColor: context.colorScheme.primary,
                                  foregroundColor:
                                      context.colorScheme.onPrimary,
                                  child: const Icon(Icons.category_rounded),
                                ),
                                title: const Text('Kategori'),
                                subtitle: Text(
                                  r.category.value?.name ??
                                      'Tidak ada kategori',
                                ),
                              ),
                            ),
                            CustomCard(
                              position: CustomCardPosition.end,
                              margin: const EdgeInsets.only(top: 2),
                              child: ListTile(
                                contentPadding: Constants.listTilePadding,
                                leading: CircleAvatar(
                                  backgroundColor: context.colorScheme.primary,
                                  foregroundColor:
                                      context.colorScheme.onPrimary,
                                  child: const Icon(Icons.today_rounded),
                                ),
                                title: const Text('Tanggal'),
                                subtitle: Text(
                                  DateFormat.yMMMMEEEEd().format(r.date),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ) ??
            EmptyContainer(),
        _ => EmptyContainer(),
      },
    );
  }
}
