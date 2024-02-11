import 'package:flutter/material.dart';

import 'colors.dart';


class DealTextStyles {
  static String bold = 'bold';
  static String regular = 'regular';
  static String mostera = 'mosteraRegular';
  static String italic = 'italic';

  final String? fontName;
  final double? fontSize;

  DealTextStyles({this.fontName = 'regular', this.fontSize = 20});

  TextStyle get textStyleDark {
    return TextStyle(
      fontFamily: fontName,
      fontSize: fontSize,
      color: CommonColors.black
    );
  }

  TextStyle get textStyleWhite {
    return TextStyle(
        fontFamily: fontName,
        fontSize: fontSize,
        color: CommonColors.dirtyWhite
    );
  }


}