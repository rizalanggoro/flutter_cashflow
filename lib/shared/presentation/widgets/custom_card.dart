import 'package:cashflow/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../constants/constants.dart';

enum CustomCardPosition { initial, start, middle, end }

enum CustomCardVariant { primary, secondary, danger }

@Deprecated('Gunakan material design 3')
class CustomCard extends HookWidget {
  final Widget child;
  final EdgeInsets? margin;
  final CustomCardPosition? position;
  final CustomCardVariant? variant;

  const CustomCard({
    super.key,
    required this.child,
    this.margin,
    this.position = CustomCardPosition.initial,
    this.variant = CustomCardVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final borderRadiuses = {
      CustomCardPosition.initial: BorderRadius.all(
        Constants.cardStartEndRadius,
      ),
      CustomCardPosition.start: BorderRadius.vertical(
        top: Constants.cardStartEndRadius,
        bottom: Constants.cardMiddleRadius,
      ),
      CustomCardPosition.middle: BorderRadius.all(
        Constants.cardMiddleRadius,
      ),
      CustomCardPosition.end: BorderRadius.vertical(
        top: Constants.cardMiddleRadius,
        bottom: Constants.cardStartEndRadius,
      ),
    };
    final colors = {
      CustomCardVariant.primary: colorScheme.primaryContainer.withOpacity(.32),
      CustomCardVariant.secondary: Colors.transparent,
      CustomCardVariant.danger: colorScheme.errorContainer.withOpacity(.32),
    };
    final borderColors = {
      CustomCardVariant.primary: colorScheme.primaryContainer,
      CustomCardVariant.secondary: colorScheme.outline.withOpacity(.32),
      CustomCardVariant.danger: colorScheme.errorContainer,
    };

    return Card(
      clipBehavior: Clip.hardEdge,
      color: colors[variant],
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadiuses[position]!,
        side: BorderSide(
          color: borderColors[variant]!,
        ),
      ),
      margin: margin ?? const EdgeInsets.all(0),
      child: child,
    );
  }
}
