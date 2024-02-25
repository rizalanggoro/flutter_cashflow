import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../data/models/category.dart';
import '../../../../domain/usecases/delete_category_by_id.dart';

class BottomSheetConfirmDeleteCategory extends HookConsumerWidget {
  final CategoryModel category;

  const BottomSheetConfirmDeleteCategory({
    super.key,
    required this.category,
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
              'Hapus kategori',
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
                    text: 'Apakah Anda yakin akan menghapus kategori ',
                  ),
                  TextSpan(
                    text: category.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(
                    text: ' dari database?',
                  ),
                  const TextSpan(
                    text: ' Tindakan Anda tidak dapat dipulihkan!',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  )
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 16,
            ),
            child: Text(
              'Harap dicatat! Menghapus kategori berarti menghapus seluruh transaksi yang terkait dengan kategori ini',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.error,
                fontStyle: FontStyle.italic,
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
              'Informasi lainnya',
              style: context.textTheme.titleMedium,
            ),
          ),

          // transactions
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.payment_rounded),
            ),
            title: const Text('Transaksi'),
            subtitle: FutureBuilder(
              future: category.transactions.count(),
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
                      .watch(deleteCategoryByIdUseCaseProvider)
                      .call(categoryId: category.id)
                      .then(
                        (value) => value.fold(
                          (l) => log(l.message),
                          (r) => context.router.pop(),
                        ),
                      ),
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
