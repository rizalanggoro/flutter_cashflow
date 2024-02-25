import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../data/models/wallet.dart';
import '../../../../domain/usecases/delete_wallet_by_id.dart';
import '../../../providers/selected_wallet.dart';

class BottomSheetConfirmDeleteWallet extends HookConsumerWidget {
  final WalletModel wallet;

  const BottomSheetConfirmDeleteWallet({
    super.key,
    required this.wallet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: Text(
              'Hapus dompet',
              style: context.textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: RichText(
              text: TextSpan(
                style: context.textTheme.bodyMedium,
                children: [
                  const TextSpan(
                      text: 'Apakah Anda yakin akan menghapus dompet '),
                  TextSpan(
                      text: wallet.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(text: ' dari database? '),
                  const TextSpan(
                      text:
                          'Tindakan yang Anda lakukan tidak dapat dipulihkan!',
                      style: TextStyle(fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ),
          const Gap(16),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: Text(
              'Harap dicatat! Menghapus dompet berarti menghapus seluruh kategori dan transaksi yang terkait dengan dompet ini',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.error,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const Gap(16),

          const Divider(),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              top: 8,
              bottom: 8,
            ),
            child: Text(
              'Informasi lainnya',
              style: context.textTheme.titleMedium,
            ),
          ),

          // categories
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.category_rounded),
            ),
            title: const Text('Kategori'),
            subtitle: FutureBuilder(
              future: wallet.categories.count(),
              builder: (context, snapshot) {
                final count = snapshot.data ?? 0;
                return Text('$count kategori akan dihapus');
              },
            ),
          ),

          // transactions
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.payment_rounded),
            ),
            title: const Text('Transaksi'),
            subtitle: FutureBuilder(
              future: wallet.transactions.count(),
              builder: (context, snapshot) {
                final count = snapshot.data ?? 0;
                return Text('$count transaksi akan dihapus');
              },
            ),
          ),

          // actions
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 32,
              horizontal: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => context.router.pop(),
                  child: const Text('Batal'),
                ),
                const Gap(8),
                FilledButton(
                  onPressed: () => ref
                      .read(deleteWalletByIdUseCaseProvider)
                      .call(walletId: wallet.id)
                      .then((value) => value.fold(
                            (l) => {},
                            (r) => ref
                                .read(selectedWalletProvider.notifier)
                                .onDelete()
                                .then((value) => context.router.pop()),
                          )),
                  child: const Text('Hapus'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
