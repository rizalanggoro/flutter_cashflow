import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  final EdgeInsets? padding;

  const LoadingContainer({
    super.key,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      alignment: Alignment.center,
      child: const CircularProgressIndicator(
        strokeCap: StrokeCap.round,
      ),
    );
  }
}
