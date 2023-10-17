import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

import '../util/colors.dart';

class ProgressBar {
  final double maxValue;
  late final double current;
  final String displayText;

  ProgressBar(this.maxValue, this.current, this.displayText);

  void calcPercentuale(double currentValue, double maxValue){
    current = (currentValue / maxValue) * 100;
  }

  Widget create(){
    return FAProgressBar(
      displayTextStyle: const TextStyle(color: Colors.black),
      progressColor: AppColors.headline,
      backgroundColor: AppColors.paragraph,
      displayText: displayText,
      currentValue: current,
      maxValue: maxValue,
    );
  }
}