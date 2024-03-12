import 'package:auto_route/auto_route.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/preferences.dart';

@RoutePage()
class SelectAppearanceColorSchemePage extends HookConsumerWidget {
  const SelectAppearanceColorSchemePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schemeKeys = FlexColor.schemes.entries.map((e) => e.key).toList();
    final colorSchemeName = ref.watch(
        preferencesProvider.select((value) => value.appearanceColorSchemeName));
    final useDarkMode = ref.watch(
        preferencesProvider.select((value) => value.appearanceUseDarkMode));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Skema Warna'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final schemeKey = schemeKeys[index];
          final schemeValue = FlexColor.schemes[schemeKey];

          if (schemeValue == null) {
            return Container();
          }

          return RadioListTile(
            value: schemeKey.name,
            groupValue: colorSchemeName,
            onChanged: (value) {
              if (value != null) {
                ref
                    .read(preferencesProvider.notifier)
                    .updateAppearanceColorScheme(colorSchemeName: value);
              }
            },
            title: Text(schemeValue.name),
            subtitle: Text(schemeValue.description),
            secondary: _colorPreview(
              useDarkMode ? schemeValue.dark : schemeValue.light,
            ),
          );
        },
        itemCount: schemeKeys.length,
      ),
    );
  }

  Widget _colorPreview(FlexSchemeColor schemeColor) {
    final colors = [
      schemeColor.primary,
      schemeColor.primaryContainer,
      schemeColor.secondary,
      schemeColor.tertiary,
    ];

    return SizedBox(
      height: 32,
      width: 32,
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        clipBehavior: Clip.hardEdge,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
          ),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: colors[index],
              ),
            );
          },
          itemCount: 4,
        ),
      ),
    );
  }
}
