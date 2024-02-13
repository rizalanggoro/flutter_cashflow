import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../core/utils/hooks.dart';
import '../../constants/constants.dart';
import 'custom_card.dart';

class FailureCard extends HookWidget {
  final String? message;
  final EdgeInsets? margin;

  const FailureCard({
    super.key,
    this.message,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = useColorScheme();

    return CustomCard(
      margin: margin,
      variant: CustomCardVariant.danger,
      child: ListTile(
        contentPadding: Constants.listTilePadding,
        leading: CircleAvatar(
          backgroundColor: colorScheme.error,
          foregroundColor: colorScheme.onError,
          child: const Icon(Icons.warning_rounded),
        ),
        title: const Text('Uh ooh!'),
        subtitle: Text(
          message ?? 'Something went wrong! Please try again',
        ),
      ),
    );
  }
}
