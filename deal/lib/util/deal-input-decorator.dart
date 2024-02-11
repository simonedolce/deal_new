
import 'package:flutter/material.dart';
import 'colors.dart';

class DealInputDecorator {
  final String label;

  DealInputDecorator({
    Key? key,
    required this.label,
  });


  InputDecoration get dealInputDecorator {
    return  InputDecoration(
      label: Text(label),
      labelStyle: const TextStyle(color: CommonColors.black),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(style: BorderStyle.solid,color: CommonColors.black, strokeAlign: 6),
      ),
      disabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(style: BorderStyle.solid,color: CommonColors.dirtyWhite, strokeAlign: 6),
      ),
      border: const OutlineInputBorder(
          borderSide: BorderSide(style: BorderStyle.solid,color: CommonColors.dirtyWhite, strokeAlign: 6),
      ),

    );
  }

}