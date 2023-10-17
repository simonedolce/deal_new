import 'dart:ui';

import 'package:flutter/material.dart';
import '../util/colors.dart';

class HeroCardWidget extends StatelessWidget {
  const HeroCardWidget({Key? key, required this.id, this.widgets, this.cardWidget, required this.detailCardWidget}) : super(key: key);

  final int id;
  final List<Widget>? widgets;
  final List<Widget>? cardWidget;
  final Widget detailCardWidget;

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
                      widgets: widgets,
                      detailCardWidget: detailCardWidget,
                    );
                  },
                ),
              );
            },
            child: Column(
              children: [
                if(cardWidget != null) ...cardWidget!
              ],
            )
          ),
        ),
      ),
    );
  }
}

class HeroCardDetails extends StatelessWidget {
  final String id;
  final List<Widget>? widgets;
  final Widget detailCardWidget;

  const HeroCardDetails({super.key, required this.id, this.widgets, required this.detailCardWidget});


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
                  child: detailCardWidget
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
