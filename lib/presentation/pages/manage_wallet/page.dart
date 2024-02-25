import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/failure/failure.dart';
import '../../../core/router/router.gr.dart';
import '../../providers/wallets.dart';
import '../../widgets/empty_container.dart';
import '../../widgets/failure_container.dart';
import '../../widgets/loading_container.dart';
import 'widgets/bottom_sheet_confirm_delete_wallet.dart';

@RoutePage()
class ManageWalletPage extends HookConsumerWidget {
  const ManageWalletPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('build: manage wallet');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dompet'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.router.push(WriteWalletRoute()),
        child: const Icon(Icons.add_rounded),
      ),
      body: ref.watch(walletsProvider).maybeWhen(
            loading: () => const LoadingContainer(),
            error: (error, stackTrace) => FailureContainer(
              message: error is Failure ? error.message : error.toString(),
            ),
            data: (data) => data.isEmpty
                ? const EmptyContainer()
                : ListView.builder(
                    itemBuilder: (context, index) {
                      final wallet = data[index];

                      return ListTile(
                        title: Text(wallet.name),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              child: ListTile(
                                leading: Icon(Icons.edit_rounded),
                                title: Text('Ubah dompet'),
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () => showModalBottomSheet(
                                context: context,
                                useSafeArea: true,
                                isScrollControlled: true,
                                showDragHandle: true,
                                builder: (context) =>
                                    BottomSheetConfirmDeleteWallet(
                                  wallet: wallet,
                                ),
                              ),
                              child: const ListTile(
                                leading: Icon(Icons.delete_rounded),
                                title: Text('Hapus dompet'),
                              ),
                            ),
                          ],
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
