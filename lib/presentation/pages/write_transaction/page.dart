import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:cashflow/domain/usecases/create_transaction.dart';
import 'package:cashflow/domain/usecases/read_transaction_by_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/router/router.gr.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/hooks.dart';
import '../../../data/models/category.dart';
import '../../../data/models/transaction.dart';
import '../../../domain/usecases/update_transaction.dart';
import '../../providers/selected_wallet.dart';

@RoutePage()
class WriteTransactionPage extends HookConsumerWidget {
  final int? transactionId;

  const WriteTransactionPage({
    super.key,
    this.transactionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('build: write transaction');

    final formatterAmount = useCurrencyInputFormatter();
    final controllerAmount = useTextEditingController();
    final controllerNote = useTextEditingController();

    final oldTransaction = useState<TransactionModel?>(null);
    final selectedCategory = useState<CategoryModel?>(null);
    final selectedDate = useState(DateTime.now());

    final transactionSnapshot = useFuture(
      transactionId == null
          ? null
          : useMemoized(() => ref
              .watch(readTransactionByIdUseCaseProvider)
              .call(transactionId: transactionId!)),
    );

    useEffect(
      () {
        if (transactionId != null) {
          if (transactionSnapshot.connectionState == ConnectionState.done) {
            transactionSnapshot.data?.fold(
              (l) => context.router.pop(),
              (r) {
                oldTransaction.value = r;
                controllerAmount.text =
                    formatterAmount.value.formatDouble(r.amount);
                controllerNote.text = r.note;
                selectedCategory.value = r.category.value;
                selectedDate.value = r.date;
              },
            );
          }
        }

        return null;
      },
      [transactionSnapshot.connectionState],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          transactionId != null && oldTransaction.value != null
              ? 'Ubah Transaksi'
              : 'Transaksi Baru',
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
              ),
              child: TextField(
                controller: controllerAmount,
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
                    onPressed: () => oldTransaction.value != null
                        ? ref
                            .read(updateTransactionUseCaseProvider)
                            .call(
                              oldTransaction: oldTransaction.value,
                              amount: formatterAmount.value
                                  .getUnformattedValue()
                                  .toDouble(),
                              note: controllerNote.text,
                              category: selectedCategory.value,
                              dateTime: selectedDate.value,
                            )
                            .then((value) => value.fold(
                                  (l) =>
                                      context.showSnackBar(message: l.message),
                                  (r) => context.router.pop(),
                                ))
                        : ref
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
