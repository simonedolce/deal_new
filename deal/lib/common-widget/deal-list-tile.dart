import 'package:deal/util/colors.dart';
import 'package:flutter/material.dart';

import '../util/deal-styles.dart';

class DealListTile{

  String title;
  String subtitle;
  void Function()? onTap;
  bool? selected;

  DealListTile({
    required this.title,
    required this.subtitle,
    this.onTap,
    this.selected = false
  });

  ListTile get dealListTile {
    return ListTile(
      onTap: onTap,
      title: Text(title, style: const TextStyle(fontFamily: 'bold')),
      subtitle: Text(subtitle,style: const TextStyle(fontFamily: 'regular')),
      textColor: Colors.white,
      shape: DealStyles.roundRectangleRadiusBorder,
      selected: selected!,
      selectedTileColor: CommonColors.secondary,
      tileColor: CommonColors.primary,


    );
  }

}