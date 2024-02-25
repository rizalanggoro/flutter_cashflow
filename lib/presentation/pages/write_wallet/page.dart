import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/router/router.gr.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/hooks.dart';
import '../../../domain/usecases/create_wallet.dart';
import '../../providers/selected_wallet.dart';

@RoutePage()
class WriteWalletPage extends HookConsumerWidget {
  final bool isCreateFirstWallet;

  const WriteWalletPage({
    super.key,
    this.isCreateFirstWallet = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerName = useTextEditingController();
    final addInitialCategories = useState(true);
    // final formatterInitialAmount = useState(CurrencyTextInputFormatter());
    final formatterInitialAmount = useCurrencyInputFormatter();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isCreateFirstWallet ? 'Dompet Pertama' : 'Dompet Baru',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 16,
              ),
              child: TextField(
                controller: controllerName,
                decoration: const InputDecoration(
                  labelText: 'Nama dompet',
                ),
              ),
            ),
            const Divider(),

            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: 8,
              ),
              child: Text(
                'Opsi lainnya',
                style: context.textTheme.titleMedium,
              ),
            ),

            // initial categories
            SwitchListTile(
              value: addInitialCategories.value,
              onChanged: (value) => addInitialCategories.value = value,
              title: const Text('Kategori awal'),
              subtitle: const Text(
                'Tambahkan beberapa kategori awal seperti makanan dan '
                'minuman, transportasi, kesehatan, dll',
              ),
            ),

            // initial amount
            if (addInitialCategories.value)
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: TextField(
                  inputFormatters: [formatterInitialAmount.value],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Saldo awal',
                    helperText: 'Saldo awal dompet yang Anda buat',
                  ),
                ),
              ),

            // actions
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 32,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!isCreateFirstWallet)
                    OutlinedButton(
                      onPressed: () => context.router.pop(),
                      child: const Text('Batal'),
                    ),
                  if (!isCreateFirstWallet) const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () => ref
                        .read(createWalletUseCaseProvider)
                        .call(
                            walletName: controllerName.text,
                            addInitialCategories: addInitialCategories.value,
                            initialAmount: formatterInitialAmount.value
                                .getUnformattedValue()
                                .toDouble())
                        .then((value) => value.fold(
                              (l) => context.showSnackBar(message: l.message),
                              (r) {
                                if (isCreateFirstWallet) {
                                  ref
                                      .read(selectedWalletProvider.notifier)
                                      .change(wallet: r);
                                  context.router.replace(const HomeRoute());
                                } else {
                                  context.router.pop();
                                }
                              },
                            )),
                    child: const Text('Selesai'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
