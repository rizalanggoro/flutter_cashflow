import 'package:flutter/material.dart';

extension XContext on BuildContext {
  showSnackBar({
    required String message,
    SnackBarAction? action,
  }) =>
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          action: action,
        ),
      );

  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  ThemeData get themeData => Theme.of(this);

  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
}
