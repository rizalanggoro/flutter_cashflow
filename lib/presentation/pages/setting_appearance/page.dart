import 'package:auto_route/auto_route.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/router/router.gr.dart';
import '../../../core/utils/extensions.dart';
import '../../providers/preferences.dart';

@RoutePage()
class SettingAppearancePage extends HookConsumerWidget {
  const SettingAppearancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useSystemTheme = ref.watch(
        preferencesProvider.select((value) => value.appearanceUseSystemTheme));
    final useDarkMode = ref.watch(
        preferencesProvider.select((value) => value.appearanceUseDarkMode));
    final useTrueDark = ref.watch(
        preferencesProvider.select((value) => value.appearanceUseTrueDark));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tema'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              value: useSystemTheme,
              onChanged: (value) => ref
                  .read(preferencesProvider.notifier)
                  .toggleAppearanceUseSystemTheme(),
              title: const Text('Sistem'),
              subtitle: const Text('Gunakan tema berdasarkan sistem saat ini'),
              secondary: const CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(Icons.contrast_outlined),
              ),
            ),
            SwitchListTile(
              value: useDarkMode,
              onChanged: useSystemTheme
                  ? null
                  : (value) => ref
                      .read(preferencesProvider.notifier)
                      .toggleAppearanceUseDarkMode(),
              title: const Text('Mode gelap'),
              subtitle:
                  const Text('Gunakan warna yang lebih nyaman untuk mata Anda'),
              secondary: const CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(Icons.dark_mode_outlined),
              ),
            ),
            SwitchListTile(
              value: useTrueDark,
              onChanged: (value) => ref
                  .read(preferencesProvider.notifier)
                  .toggleAppearanceUseTrueDark(),
              title: const Text('Gunakan hitam pekat'),
              secondary: const CircleAvatar(
                backgroundColor: Colors.transparent,
              ),
            ),
            const Divider(),
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
                child: Icon(Icons.palette_outlined),
              ),
              title: const Text('Skema warna'),
              subtitle: Text(
                FlexColor.schemes.entries
                        .where((element) =>
                            element.key.name ==
                            ref.watch(preferencesProvider.select(
                                (value) => value.appearanceColorSchemeName)))
                        .firstOrNull
                        ?.value
                        .name ??
                    'Tidak ditemukan',
              ),
              onTap: () => context.router.push(
                const SelectAppearanceColorSchemeRoute(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
