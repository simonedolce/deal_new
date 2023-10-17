import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';
import 'package:omc/common_widget/Input_decoration.dart';
import 'package:omc/util/colors.dart';
import 'package:omc/util/strings.dart';

class InputField extends StatelessWidget {
   InputField({
        Key? key,
        required this.label,
        this.integer = false,
        this.decimal = false,
        required this.obscure,
        this.validatorFunc,
        required this.controller,
        this.maxValue,
        this.onChanged
      }) : super(key: key);

  final String label;
  final bool obscure;
  final bool integer;
  final bool decimal;
  final String? Function(String?)? validatorFunc;
  final TextEditingController controller;
  final double? maxValue;
  final String? Function(String?)?  onChanged;
  get obscureFlag => false;

  String? isNull(String? formText){
    if(formText == null || formText.isEmpty) return Strings.required;
    return null;
  }

  @override
  Widget build(BuildContext context) {

    if(integer){
      CustomInputDecoration customInputDecoration = CustomInputDecoration(label: label);
      String maxValueString = maxValue == null ? "9999999999999" : maxValue.toString();
      return TextFormField(
          controller: controller,
          decoration: customInputDecoration.borderInput,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: <TextInputFormatter>[
            //FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
            //LengthLimitingTextInputFormatter(8),
            CurrencyTextInputFormatter(
              integerDigits: 10,
              decimalDigits: 2,
              maxValue: maxValueString,
              decimalSeparator: '.',
              groupDigits: 3,
              groupSeparator: ',',
              allowNegative: false,
              overrideDecimalPoint: true,
              insertDecimalPoint: false,
              insertDecimalDigits: false,
            ),// Imposta la lunghezza massima a 8 (6 cifre intere + 1 punto + 2 cifre decimali)
          ],
          obscureText: obscureFlag,
          validator: validatorFunc ?? (value) => isNull(value),
          onChanged: onChanged,

      );
    }

    return TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.highlight),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.highlight)
          ),
        ),
        obscureText: obscureFlag,
        validator: validatorFunc ?? (value) => isNull(value)
    );

  }
}

