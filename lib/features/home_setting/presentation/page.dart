import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/router/router.gr.dart';
import '../../../core/utils/extensions.dart';
import '../../../shared/data/providers/isar.dart';
import '../../../shared/presentation/providers/expense_categories.dart';
import '../../../shared/presentation/providers/income_categories.dart';
import '../../../shared/presentation/providers/selected_wallet.dart';
import '../../../shared/presentation/providers/theme.dart';
import '../domain/usecases/dummy_transactions.dart';

@RoutePage()
class HomeSettingPage extends HookConsumerWidget {
  const HomeSettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // theme
          SwitchListTile(
            value: ref.watch(themeProvider) == ThemeMode.dark,
            onChanged: (value) => ref
                .read(themeProvider.notifier)
                .change(themeMode: value ? ThemeMode.dark : ThemeMode.light),
            title: const Text('Mode gelap'),
            subtitle: const Text(
              'Gunakan tampilan yang lebih nyaman untuk mata Anda',
            ),
            secondary: const CircleAvatar(
              child: Icon(Icons.dark_mode_rounded),
            ),
          ),
          const Divider(),

          // manage wallet
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.wallet_rounded),
            ),
            title: const Text('Kelola dompet'),
            subtitle: const Text(
              'Buat, ubah, dan hapus dompet yang Anda miliki',
            ),
            onTap: () => context.router.push(
              const ManageWalletRoute(),
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),

          // manage category
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.category_rounded),
            ),
            title: const Text('Kelola kategori'),
            subtitle: const Text(
              'Buat, ubah, dan hapus kategori untuk setiap dompet yang Anda miliki',
            ),
            onTap: () => context.router.push(
              const ManageCategoryRoute(),
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
          const Divider(),

          // about
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              top: 8,
              bottom: 8,
            ),
            child: Text(
              'Tentang',
              style: context.textTheme.titleMedium,
            ),
          ),
          const ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.info_rounded),
            ),
            title: Text('Status aplikasi'),
            subtitle: Text('Dalam tahap pengembangan'),
          ),
          const Divider(),

          // debug
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              top: 8,
              bottom: 8,
            ),
            child: Text(
              'Debugging',
              style: context.textTheme.titleMedium,
            ),
          ),
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.delete_rounded),
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
            title: const Text('Hapus database'),
            subtitle: const Text(
              'Hapus semua database: wallets, categories, transactions',
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Hapus database'),
                  content: const Text(
                    'Hapus semua isar database: wallets, categories, transactions',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => context.router.pop(),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        final isar = ref.watch(isarProvider).instance;
                        isar.writeTxn(() => isar.clear()).then(
                            (value) => context.router.replace(WriteWalletRoute(
                                  isCreateFirstWallet: true,
                                )));
                      },
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.payment_rounded),
            ),
            trailing: Icon(Icons.chevron_right_rounded),
            title: Text('Dummy transaksi'),
            subtitle: Text(
              'Tambahkan beberapa transaksi dummy untuk kebutuhan debugging',
            ),
            onTap: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Dummy transaksi'),
                content: Text(
                  'Tambahkan 10 dummy transaksi secara random ke database?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => context.router.pop(),
                    child: const Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () => ref
                        .read(dummyTransactionsUseCaseProvider)
                        .call(
                          wallet: ref.read(selectedWalletProvider).value,
                          incomeCategories:
                              ref.read(incomeCategoriesProvider).value,
                          expenseCategories:
                              ref.read(expenseCategoriesProvider).value,
                        )
                        .then(
                          (value) => value.fold(
                            (l) => context.showSnackBar(message: l.message),
                            (r) => context.showSnackBar(
                              message:
                                  'Berhasil menambahkan 10 dummy transaksi',
                            ),
                          ),
                        )
                        .whenComplete(
                          () => context.router.pop(),
                        ),
                    child: const Text('Ya'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
