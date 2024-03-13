import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/constants/constants.dart';
import '../../../core/enums/category_type.dart';
import '../../../core/utils/extensions.dart';
import '../../../domain/usecases/create_category.dart';
import '../../models/category_type_item.dart';
import '../../providers/selected_wallet.dart';

@RoutePage()
class WriteCategoryPage extends HookConsumerWidget {
  const WriteCategoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerName = useTextEditingController();

    // states
    final selectedCategoryType = useState(CategoryType.income);

    return Scaffold(
      appBar: AppBar(title: const Text('Kategori Baru')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // category name
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
              ),
              child: TextField(
                controller: controllerName,
                decoration: const InputDecoration(
                  labelText: 'Nama kategori',
                ),
              ),
            ),

            // category type
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Text(
                'Tipe kategori',
                style: context.textTheme.titleMedium,
              ),
            ),
            ...<CategoryTypeItem>[
              CategoryTypeItem(
                title: 'Pemasukan',
                icon: Icons.south_west_rounded,
                type: CategoryType.income,
              ),
              CategoryTypeItem(
                title: 'Pengeluaran',
                icon: Icons.north_east_rounded,
                type: CategoryType.expense,
              ),
            ].map(
              (e) => RadioListTile(
                value: e.type,
                groupValue: selectedCategoryType.value,
                onChanged: (value) =>
                    selectedCategoryType.value = value ?? CategoryType.income,
                title: Text(e.title),
                secondary: CircleAvatar(child: Icon(e.icon)),
              ),
            ),
            const Divider(),

            // wallet info
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
            ListTile(
              contentPadding: Constants.listTilePadding,
              leading: const CircleAvatar(
                child: Icon(Icons.wallet_rounded),
              ),
              title: const Text('Dompet'),
              subtitle: Text(
                'Kategori baru akan disimpan dalam dompet ${ref.watch(selectedWalletProvider).maybeWhen(
                      data: (data) => data?.name ?? '-',
                      orElse: () => '-',
                    )}',
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
                        .read(createCategoryUseCaseProvider)
                        .call(
                            categoryName: controllerName.text,
                            categoryType: selectedCategoryType.value,
                            wallet: ref.read(selectedWalletProvider).value)
                        .then((value) => value.fold(
                              (l) => context.showSnackBar(message: l.message),
                              (r) => context.router.pop(),
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
