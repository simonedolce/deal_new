import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:omc/util/costants.dart';

import '../util/colors.dart';

class CommonWidget{

  Widget incDecInput(
      TextEditingController controller,
      double initValue,
      {
        IconData? icon,
        num? incDecFactor,
        ValueCallBack? onChangedFunct,
        ValueCallBack? onIncrementFunct,
        ValueCallBack? onDecrement,
        num? maxValue,
        num? minValue,
      }) {
    return NumberInputWithIncrementDecrement(
      controller: controller,
      initialValue: initValue,
      onChanged: onChangedFunct ?? (value) {},
      onIncrement: onIncrementFunct ?? (value) {},
      onDecrement: onDecrement ?? (value) {},
      isInt: false,
      incDecFactor: incDecFactor ?? Costants.decrementoQuantita,
      incDecBgColor: AppColors.highlight,
      buttonArrangement: ButtonArrangement.rightEnd,
      max: maxValue ?? double.infinity,
      min: minValue ?? 0,
      autovalidateMode: AutovalidateMode.disabled,
      numberFieldDecoration: InputDecoration(
        icon: icon != null ? Icon(icon, color: AppColors.highlight,) : null,
        border: InputBorder.none,

      ),
      widgetContainerDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
              Radius.circular(10)
          ),
          border: Border.all(
            color: AppColors.highlight,
            width: 3,
          )
      ),
      separateIcons: true,
      incIconDecoration: const BoxDecoration(
        color: AppColors.highlight,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
        ),
      ),
      decIconDecoration: const BoxDecoration(
        color: AppColors.highlight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
        ),
      ),
      incIconSize: 35,
      decIconSize: 35,

    );
  }

  Widget progressBarPercentuale(double valore,String valoreSecondario){
    return FAProgressBar(
      animatedDuration: const Duration(seconds: 1),
      currentValue: valore.isNaN ? 0 : valore,
      displayText: '% ($valoreSecondario)',
      displayTextStyle: const TextStyle(color: Colors.black, fontFamily: 'medium' , fontSize: 20),
      size: 60,
      backgroundColor: AppColors.paragraph,
      progressColor: AppColors.highlight,
      maxValue: 100,
    );
  }

}