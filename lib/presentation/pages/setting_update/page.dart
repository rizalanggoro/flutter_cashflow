import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/utils/extensions.dart';
import '../../../domain/usecases/check_update.dart';

@RoutePage()
class SettingUpdatePage extends HookConsumerWidget {
  const SettingUpdatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCheckingUpdate = useState(false);

    return Scaffold(
      appBar: AppBar(title: const Text('Pembaruan')),
      body: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.info_outlined),
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
            leading: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.label_outlined),
            ),
            title: const Text('Daftar rilis'),
            subtitle: const Text(
              'Lihat daftar rilis pada GitHub',
            ),
            onTap: () => launchUrl(
              Uri.parse(
                'https://github.com/rizalanggoro/flutter-cashflow/releases',
              ),
              mode: LaunchMode.externalApplication,
            ),
          ),
          ListTile(
            enabled: !isCheckingUpdate.value,
            leading: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.update_outlined),
            ),
            title: const Text('Periksa pembaruan'),
            subtitle: Text(
              isCheckingUpdate.value
                  ? 'Memeriksa pembaruan...'
                  : 'Tekan untuk memeriksa pembaruan',
            ),
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
          ),
        ],
      ),
    );
  }
}
