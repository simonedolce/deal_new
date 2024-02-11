import 'package:deal/util/colors.dart';
import 'package:flutter/material.dart';

class DealStyles {
  static RoundedRectangleBorder roundRectangleRadiusBorder =
  const RoundedRectangleBorder(
    side: BorderSide(
      strokeAlign: 2,
      width: 0.5
    ),
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(5),
          bottomRight: Radius.circular(10),
          bottomLeft: Radius.circular(30)
      )
  );

  static BorderRadius dealRadius =
      const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(5),
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(5)
      );

  static TextStyle bold = const TextStyle(fontFamily: 'bold', color: CommonColors.black);
  static TextStyle regular = const TextStyle(fontFamily: 'regular', color: CommonColors.black);
  static TextStyle mostera = const TextStyle(fontFamily: 'mosteraRegular', color: CommonColors.black);
  static TextStyle italic = const TextStyle(fontFamily: 'italic', color: CommonColors.black);

  static TextStyle boldWhite = const TextStyle(fontFamily: 'bold', color: CommonColors.dirtyWhite);
  static TextStyle regularWhite = const TextStyle(fontFamily: 'regular', color: CommonColors.dirtyWhite);
  static TextStyle mosteraWhite = const TextStyle(fontFamily: 'mosteraRegular', color: CommonColors.dirtyWhite);
  static TextStyle italicWhite = const TextStyle(fontFamily: 'italic', color: CommonColors.dirtyWhite);

}