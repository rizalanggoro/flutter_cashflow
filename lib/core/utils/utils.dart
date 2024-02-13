import 'package:flutter/material.dart';

class Utils {
  @Deprecated('Gunakan method context.showSnackBar()')
  static void showSnackBar({
    required BuildContext context,
    required String message,
  }) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
}
