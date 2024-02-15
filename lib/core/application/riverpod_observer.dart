import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyRiverpodObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    super.didUpdateProvider(
      provider,
      previousValue,
      newValue,
      container,
    );

    log(
      '[${provider.name ?? provider.runtimeType}] '
      '${previousValue.toString()} -> ${newValue.toString()}',
    );
  }
}
