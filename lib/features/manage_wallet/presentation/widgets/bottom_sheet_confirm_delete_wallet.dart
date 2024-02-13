import 'package:auto_route/auto_route.dart';
import 'package:cashflow/core/utils/extensions.dart';
import 'package:cashflow/features/manage_wallet/domain/usecases/delete_wallet.dart';
import 'package:cashflow/shared/presentation/providers/selected_wallet.dart';
import 'package:cashflow/shared/presentation/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/constants/constants.dart';
import '../../../../shared/data/models/wallet.dart';

class BottomSheetConfirmDeleteWallet extends HookConsumerWidget {
  final WalletModel wallet;

  const BottomSheetConfirmDeleteWallet({
    super.key,
    required this.wallet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FractionallySizedBox(
      heightFactor: Constants.bottomSheetHeightFactor,
      widthFactor: 1,
      child: Column(
        children: [
          // content
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hapus dompet',
                      style: context.textTheme.titleLarge,
                    ),
                    RichText(
                      text: TextSpan(
                        style: context.textTheme.bodyMedium,
                        children: [
                          const TextSpan(
                              text: 'Apakah Anda yakin akan menghapus dompet '),
                          TextSpan(
                              text: wallet.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(text: ' dari database? '),
                          const TextSpan(
                              text:
                                  'Tindakan yang Anda lakukan tidak dapat dipulihkan!',
                              style: TextStyle(fontStyle: FontStyle.italic)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Harap dicatat! Menghapus dompet berarti menghapus seluruh kategori dan transaksi yang terkait dengan dompet ini',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.error,
                        fontStyle: FontStyle.italic,
                      ),
                    ),

                    // categories
                    CustomCard(
                      position: CustomCardPosition.start,
                      variant: CustomCardVariant.secondary,
                      margin: const EdgeInsets.only(top: 16),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: context.colorScheme.primary,
                          foregroundColor: context.colorScheme.onPrimary,
                          child: const Icon(Icons.category_rounded),
                        ),
                        title: const Text('Kategori'),
                        subtitle: FutureBuilder(
                          future: wallet.categories.count(),
                          builder: (context, snapshot) => Text(
                            'Terdapat ${snapshot.data ?? '-'} kategori yang akan dihapus',
                          ),
                        ),
                        contentPadding: Constants.listTilePadding,
                      ),
                    ),

                    // transactions
                    CustomCard(
                      position: CustomCardPosition.end,
                      variant: CustomCardVariant.secondary,
                      margin: const EdgeInsets.only(
                        top: 4,
                        bottom: 16,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: context.colorScheme.primary,
                          foregroundColor: context.colorScheme.onPrimary,
                          child: const Icon(Icons.payment_rounded),
                        ),
                        title: const Text('Transaksi'),
                        subtitle: FutureBuilder(
                          future: wallet.categories.count(),
                          builder: (context, snapshot) => Text(
                            'Terdapat ${snapshot.data ?? '-'} transaksi yang akan dihapus',
                          ),
                        ),
                        contentPadding: Constants.listTilePadding,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // actions
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 16,
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => ref
                        .read(deleteWalletUseCaseProvider)
                        .call(id: wallet.id)
                        .then((value) => value.fold(
                              (l) => {},
                              (r) => ref
                                  .read(selectedWalletProvider.notifier)
                                  .onDelete()
                                  .then((value) => context.router.pop()),
                            )),
                    child: const Text('Hapus'),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.router.pop(),
                    child: const Text('Batal'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
