import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/utils/hooks.dart';
import '../../../../shared/constants/constants.dart';
import '../../../../shared/data/models/category.dart';
import '../../domain/usecases/delete_category.dart';

class BottomSheetConfirmDeleteCategory extends HookConsumerWidget {
  final CategoryModel category;

  const BottomSheetConfirmDeleteCategory({
    super.key,
    required this.category,
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
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hapus kategori',
                    style: useTextTheme().titleLarge,
                  ),
                  RichText(
                    text: TextSpan(
                      style: useTextTheme().bodyMedium,
                      children: [
                        const TextSpan(
                          text: 'Apakah Anda yakin akan menghapus kategori ',
                        ),
                        TextSpan(
                          text: category.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text: ' dari database? Tindakan Anda tidak '
                              'dapat dipulihkan!',
                        ),
                      ],
                    ),
                  ),
                ],
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
                        .watch(deleteCategoryUseCaseProvider)
                        .call(categoryId: category.id)
                        .then(
                          (value) => value.fold(
                            (l) => log(l.message),
                            (r) => context.router.pop(),
                          ),
                        ),
                    style: FilledButton.styleFrom(
                      backgroundColor: useColorScheme().error,
                    ),
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
