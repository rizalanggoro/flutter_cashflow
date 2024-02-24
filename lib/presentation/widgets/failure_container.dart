import 'package:flutter/material.dart';

import '../../core/utils/extensions.dart';

class FailureContainer extends StatelessWidget {
  final String message;

  const FailureContainer({
    super.key,
    this.message = 'Terjadi kesalahan tidak terduga! Silahkan coba lagi nanti',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            child: Icon(Icons.warning_rounded),
          ),
          const SizedBox(height: 16),
          Text(
            'Oops!',
            style: context.textTheme.titleMedium,
          ),
          Text(
            message,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
