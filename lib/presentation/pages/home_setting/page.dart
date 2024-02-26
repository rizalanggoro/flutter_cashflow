import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/router/router.gr.dart';
import '../../../core/utils/extensions.dart';
import '../../../data/sources/isar.dart';
import '../../../domain/usecases/check_update.dart';
import '../../../domain/usecases/create_dummy_transactions.dart';
import '../../providers/expense_categories.dart';
import '../../providers/income_categories.dart';
import '../../providers/preferences.dart';
import '../../providers/selected_wallet.dart';

@RoutePage()
class HomeSettingPage extends HookConsumerWidget {
  const HomeSettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCheckingUpdate = useState(false);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // theme
          SwitchListTile(
            value: ref.watch(
                preferencesProvider.select((value) => value.darkThemeEnable)),
            onChanged: (value) =>
                ref.read(preferencesProvider.notifier).toggleDarkTheme(),
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

          // dashboard
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              top: 8,
              bottom: 8,
            ),
            child: Text(
              'Ringkasan',
              style: context.textTheme.titleMedium,
            ),
          ),
          SwitchListTile(
            value: ref.watch(
              preferencesProvider.select(
                (value) => value.currentWalletSummaryCardVisible,
              ),
            ),
            onChanged: (value) => ref
                .read(preferencesProvider.notifier)
                .toggleCurrentWalletSummaryCardVisibility(),
            title: const Text('Dompet saat ini'),
            subtitle: const Text(
              'Tampilkan kartu ringkasan untuk dompet saat ini',
            ),
            secondary: const CircleAvatar(
              child: Icon(Icons.dashboard_rounded),
            ),
          ),
          SwitchListTile(
            value: ref.watch(
              preferencesProvider.select(
                (value) => value.allWalletsSummaryCardVisible,
              ),
            ),
            onChanged: (value) => ref
                .read(preferencesProvider.notifier)
                .toggleAllWalletsSummaryCardVisibility(),
            title: const Text('Semua dompet'),
            subtitle: const Text(
              'Tampilkan kartu ringkasan saldo semua dompet',
            ),
            secondary: const CircleAvatar(
              backgroundColor: Colors.transparent,
            ),
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
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.info_rounded),
            ),
            title: const Text('Versi'),
            subtitle: FutureBuilder(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) => Text(
                '${(snapshot.data?.version)}+${snapshot.data?.buildNumber}',
              ),
            ),
          ),
          ListTile(
            enabled: !isCheckingUpdate.value,
            leading: const CircleAvatar(
              child: Icon(Icons.update_rounded),
            ),
            title: const Text('Periksa pembaruan'),
            onTap: isCheckingUpdate.value
                ? null
                : () {
                    isCheckingUpdate.value = true;
                    ref
                        .read(checkUpdateUseCaseProvider)
                        .call()
                        .then(
                          (value) => value.fold(
                            (l) => context.showSnackBar(message: l.message),
                            (r) => r == null
                                ? context.showSnackBar(
                                    message: 'Tidak ada pembaruan!',
                                  )
                                : context.showSnackBar(
                                    message: 'Tersedia pembaruan!',
                                    action: SnackBarAction(
                                      label: 'Unduh',
                                      onPressed: () => launchUrl(
                                        Uri.parse(r.downloadUrl),
                                        mode: LaunchMode.externalApplication,
                                      ),
                                    ),
                                  ),
                          ),
                        )
                        .whenComplete(
                          () => isCheckingUpdate.value = false,
                        );
                  },
            trailing: isCheckingUpdate.value
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeCap: StrokeCap.round,
                      strokeWidth: 3.2,
                    ),
                  )
                : const Icon(Icons.chevron_right_rounded),
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
