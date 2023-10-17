import 'package:flutter/material.dart';
import '../util/colors.dart';

class CustomButtonStyle {

  static ButtonStyle outlinedButton = ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: AppColors.highlight),
      ),
    ),
    foregroundColor: MaterialStateProperty.all<Color>(AppColors.headline),
    side: MaterialStateProperty.all<BorderSide>(
      const BorderSide(color: AppColors.highlight),
    ),
  );

  static ButtonStyle elevatedButton = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(AppColors.highlight),
  );

}
