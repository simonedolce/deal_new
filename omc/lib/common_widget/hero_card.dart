import 'dart:ui';

import 'package:flutter/material.dart';
import '../util/colors.dart';

class HeroCard extends StatelessWidget {
  const HeroCard({Key? key, required this.text, required this.subtext, required this.id, this.widgets}) : super(key: key);

  final String text;
  final String subtext;
  final int id;
  final List<Widget>? widgets;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: id,
      child: Material(
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false, // Questo è importante per mantenere lo sfondo visibile
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return HeroCardDetails(
                      id: id.toString(),
                      text: text,
                      subtext: subtext,
                      widgets: widgets,
                    );
                  },
                ),
              );
            },
            child: ListTile(
              title: Text(text),
              subtitle: Text(subtext),
            ),
          ),
        ),
      ),
    );
  }
}

class HeroCardDetails extends StatelessWidget {
  final String id;
  final String text;
  final String subtext;
  final List<Widget>? widgets;

  HeroCardDetails({super.key, required this.id, required this.text, required this.subtext, this.widgets});


  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.transparent,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: id,
              child: Material(
                child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    title: Text(text),
                    subtitle: Text(subtext),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Material(
                child: Form(
                  child: Column(
                    children: [
                      if (widgets != null) ...widgets!,

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
