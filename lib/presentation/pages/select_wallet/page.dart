import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/failure/failure.dart';
import '../../../core/router/router.gr.dart';
import '../../providers/selected_wallet.dart';
import '../../providers/wallets.dart';
import '../../widgets/empty_container.dart';
import '../../widgets/failure_container.dart';
import '../../widgets/loading_container.dart';

@RoutePage()
class SelectWalletPage extends HookConsumerWidget {
  const SelectWalletPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Dompet'),
        actions: [
          IconButton(
            onPressed: () => context.router.popAndPush(
              WriteWalletRoute(),
            ),
            icon: const Icon(Icons.add_rounded),
          ),
          const Gap(16),
        ],
      ),
      body: ref.watch(walletsProvider).maybeWhen(
            loading: () => const LoadingContainer(),
            error: (error, _) => FailureContainer(
              message: error is Failure ? error.message : error.toString(),
            ),
            data: (data) => data.isEmpty
                ? const EmptyContainer()
                : ListView.builder(
                    itemBuilder: (context, index) {
                      final wallet = data[index];

                      return RadioListTile(
                        value: wallet.id,
                        groupValue: ref.watch(selectedWalletProvider).value?.id,
                        onChanged: (value) {
                          ref
                              .read(selectedWalletProvider.notifier)
                              .change(wallet: wallet);
                          context.router.pop();
                        },
                        title: Text(wallet.name),
                        subtitle: FutureBuilder(
                          future: wallet.categories.count(),
                          builder: (context, snapshot) {
                            final count = snapshot.data ?? 0;

                            return Text(Intl.plural(
                              count,
                              zero: 'Tidak ada kategori',
                              other: '$count kategori',
                            ));
                          },
                        ),
                      );
                    },
                    itemCount: data.length,
                  ),
            orElse: () => const EmptyContainer(),
          ),
    );
  }
}
