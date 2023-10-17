import 'package:flutter/material.dart';

import '../util/colors.dart';

class CustomInputDecoration {
   final String label;
   Icon? icon;

   CustomInputDecoration({
    Key? key,
    required this.label,
    this.icon
  });

   InputDecoration get borderInput {
     return InputDecoration(
       labelText: label,
       icon: icon,
       labelStyle: const TextStyle(color: AppColors.highlight),
       border: const OutlineInputBorder(
         borderSide: BorderSide(color: AppColors.highlight),
       ),
     );
   }

}


