import 'package:flutter/material.dart';

import '../util/colors.dart';
class SimpleTable extends StatelessWidget {
  final Map<String, String> rows;

  const SimpleTable({Key? key, required this.rows}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: rows.length,
      itemBuilder: (context, index) {
        final key = rows.keys.elementAt(index);
        final value = rows[key];

        return ListTile(
          style: ListTileStyle.list,
          shape: const BeveledRectangleBorder(
            side: BorderSide(
                color: AppColors.highlight
            ),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          title: Text(
            key,
            style: const TextStyle(fontFamily: 'bold'),
          ),
          subtitle: Text(value!,style: const TextStyle(fontFamily: 'mediumItalic')),
        );
      },
    );
  }
}
