import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/router/router.gr.dart';
import '../../../core/utils/extensions.dart';
import '../../../data/sources/isar.dart';
import '../../../domain/usecases/create_dummy_transactions.dart';
import '../../providers/expense_categories.dart';
import '../../providers/income_categories.dart';
import '../../providers/selected_wallet.dart';

@RoutePage()
class HomeSettingPage extends HookConsumerWidget {
  const HomeSettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // manage wallet
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.wallet_rounded),
            ),
            title: const Text('Dompet'),
            subtitle: const Text(
              'Buat, ubah, dan hapus dompet yang Anda miliki',
            ),
            onTap: () => context.router.push(
              const ManageWalletRoute(),
            ),
          ),

          // manage category
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.category_rounded),
            ),
            title: const Text('Kategori'),
            subtitle: const Text(
              'Buat, ubah, dan hapus kategori untuk setiap dompet yang Anda miliki',
            ),
            onTap: () => context.router.push(
              const ManageCategoryRoute(),
            ),
          ),
          const Divider(),

          // other settings
          const Gap(8),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Text(
              'Lainnya',
              style: context.textTheme.titleMedium,
            ),
          ),
          const Gap(8),

          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.brush_outlined),
            ),
            title: const Text('Tema dan warna'),
            onTap: () => context.router.push(
              const SettingAppearanceRoute(),
            ),
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.dashboard_outlined),
            ),
            title: const Text('Widget ringkasan'),
            onTap: () => context.router.push(
              const SettingDashboardRoute(),
            ),
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.update_outlined),
            ),
            title: const Text('Pembaruan'),
            onTap: () => context.router.push(
              const SettingUpdateRoute(),
            ),
          ),

          if (kDebugMode) const Divider(),

          // debug
          if (kDebugMode)
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
          if (kDebugMode)
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.transparent,
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
                          final isar = ref.watch(isarSourceProvider).instance;
                          isar.writeTxn(() => isar.clear()).then((value) =>
                              context.router.replace(WriteWalletRoute(
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
          if (kDebugMode)
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(Icons.payment_rounded),
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              title: const Text('Dummy transaksi'),
              subtitle: const Text(
                'Tambahkan beberapa transaksi dummy untuk kebutuhan debugging',
              ),
              onTap: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Dummy transaksi'),
                  content: const Text(
                    'Tambahkan 10 dummy transaksi secara random ke database?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => context.router.pop(),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () => ref
                          .read(createDummyTransactionsUseCaseProvider)
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

          // spacer
          const Gap(32),
        ],
      ),
    );
  }
}
