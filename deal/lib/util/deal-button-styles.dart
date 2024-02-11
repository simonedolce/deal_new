import 'package:deal/util/colors.dart';
import 'package:flutter/material.dart';

class DealButtonStyles {
  static ButtonStyle outlinedButton = ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: CommonColors.dark),
      ),
    ),
    foregroundColor: MaterialStateProperty.all<Color>(CommonColors.primary),
    side: MaterialStateProperty.all<BorderSide>(
      const BorderSide(color: CommonColors.primary),
    ),
  );

  static ButtonStyle elevatedButton = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(CommonColors.primary),
  );
}