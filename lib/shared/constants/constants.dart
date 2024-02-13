import 'package:flutter/material.dart';

class Constants {
  static get bottomSheetHeightFactor => .84;

  // padding
  static get listTilePadding => const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 16,
      );
  static get inputPadding => const EdgeInsets.all(16);

  // border
  static get inputBorderWidth => 1.32;

  // radius
  static get inputRadius => const Radius.circular(8);
  static get buttonRadius => const Radius.circular(8);
  static get cardStartEndRadius => const Radius.circular(12);
  static get cardMiddleRadius => const Radius.circular(4);
}
