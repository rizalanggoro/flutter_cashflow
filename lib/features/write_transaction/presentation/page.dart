import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/router/router.gr.dart';
import '../../../core/utils/extensions.dart';
import '../../../shared/data/models/category.dart';
import '../../../shared/presentation/providers/selected_wallet.dart';
import '../domain/usecases/create_transaction.dart';

@RoutePage()
class WriteTransactionPage extends HookConsumerWidget {
  const WriteTransactionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('build: write transaction');

    final formatterAmount = useState(CurrencyTextInputFormatter());
    final controllerNote = useTextEditingController();

    final selectedCategory = useState<CategoryModel?>(null);
    final selectedDate = useState(DateTime.now());

    return Scaffold(
      appBar: AppBar(title: const Text('Transaksi Baru')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
              ),
              child: TextField(
                inputFormatters: [formatterAmount.value],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nominal transaksi',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
              ),
              child: TextField(
                controller: controllerNote,
                maxLines: null,
                minLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Catatan',
                  alignLabelWithHint: true,
                ),
              ),
            ),
            const Gap(16),

            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                bottom: 8,
              ),
              child: Text(
                'Detail transaksi',
                style: context.textTheme.titleMedium,
              ),
            ),

            // category
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.category_rounded),
              ),
              title: const Text('Kategori'),
              subtitle: Text(
                selectedCategory.value?.name ?? 'Tidak ada kategori dipilih',
              ),
              onTap: () => context.router
                  .push(SelectCategoryRoute(
                      initialCategory: selectedCategory.value))
                  .then((value) {
                if (value is CategoryModel) {
                  selectedCategory.value = value;
                }
              }),
              trailing: const Icon(Icons.chevron_right_rounded),
            ),

            // date
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.date_range_rounded),
              ),
              title: const Text('Tanggal'),
              subtitle: Text(
                DateFormat.yMMMMEEEEd().format(selectedDate.value),
              ),
              onTap: () => showDatePicker(
                context: context,
                firstDate: DateTime(selectedDate.value.year - 1),
                lastDate: DateTime(selectedDate.value.year + 1),
                initialDate: selectedDate.value,
              ).then((value) {
                if (value != null) {
                  selectedDate.value = value;
                }
              }),
              trailing: const Icon(Icons.chevron_right_rounded),
            ),

            const Divider(),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                top: 8,
                bottom: 8,
              ),
              child: Text(
                'Lainnya',
                style: context.textTheme.titleMedium,
              ),
            ),

            // wallet
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.wallet_rounded),
              ),
              title: const Text('Dompet'),
              subtitle: ref.watch(selectedWalletProvider).maybeWhen(
                    data: (data) => data != null
                        ? Text(
                            'Transaksi baru akan disimpan '
                            'pada dompet ${data.name}',
                          )
                        : const Text('Tidak ada dompet yang dipilih'),
                    orElse: () => const Text(
                      'Tidak ada dompet yang dipilih',
                    ),
                  ),
            ),

            // actions
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 32,
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
                        .read(createTransactionUseCaseProvider)
                        .call(
                          amount: formatterAmount.value
                              .getUnformattedValue()
                              .toDouble(),
                          note: controllerNote.text,
                          wallet: ref.read(selectedWalletProvider).value,
                          category: selectedCategory.value,
                          dateTime: selectedDate.value,
                        )
                        .then((value) => value.fold(
                            (l) => context.showSnackBar(message: l.message),
                            (r) => context.router.pop())),
                    child: const Text('Selesai'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
