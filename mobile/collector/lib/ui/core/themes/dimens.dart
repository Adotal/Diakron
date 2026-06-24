import 'package:flutter/material.dart';

abstract final class Dimens {
  const Dimens();

  /// General horizontal padding used to separate UI items
  static const paddingHorizontal = 20.0;
  static const formPaddingHorizontal = 30.0;

  /// General vertical padding used to separate UI items
  static const paddingVertical = 20.0;
  static const longPaddingVertical = 25.0;

  static const fontSmall = 12.0;
  static const fontMedium = 18.0;
  static const fontBig = 30.0;
  static const fontTitle = 40.0;
  static const fontSubtitle = 30.0;

  /// Get dimensions of screen size
  static Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
}
