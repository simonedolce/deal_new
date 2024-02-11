import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:deal/main.dart';
import 'package:deal/model/deal-product.dart';
import 'package:deal/services/deal-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

import '../../common-widget/deal-list-tile.dart';
import '../../model/deal.dart';
import '../../util/colors.dart';
import '../../util/routes.dart';

class ConfermaDeal extends StatefulWidget {

  final Deal deal;

  const ConfermaDeal({super.key, required this.deal});

  @override
  State<ConfermaDeal> createState() => _ConfermaDealState();
}

class _ConfermaDealState extends State<ConfermaDeal> {

  DealService dealService = DealService();

  @override
  Widget build(BuildContext context) {
    Deal deal = widget.deal;
    double totalePagato = calcolaTotalePagato(deal);
    double introitoPrevisto = calcolaIntroitoPrevisto(deal);
    double percentuale = (introitoPrevisto / totalePagato) * 100;

    return Scaffold(
      appBar: AppBar(backgroundColor: CommonColors.background,title: const Text("Riepilogo" , style: TextStyle(fontFamily: 'mosteraRegular'))),
      persistentFooterButtons: [
        AnimatedButton(
          text: 'Continua',
          color: CommonColors.primary,
          pressEvent: () {
            AwesomeDialog(
              context: context,
              customHeader: Image.asset('images/char.png'),

              dialogType: DialogType.warning,
              headerAnimationLoop: false,
              animType: AnimType.rightSlide,
              showCloseIcon: true,
              closeIcon: const Icon(Icons.dangerous_rounded),
              title: 'Attenzione!',
              titleTextStyle: const TextStyle(fontFamily: 'bold'),
              descTextStyle: const TextStyle(fontFamily: 'regular'),
              desc:
              "Si procederà con il salvataggio del Deal. Per favore, dai un'ultima occhiata e assicurati che i conti tornino.",
              btnCancelOnPress: () {},
              onDismissCallback: (type) {
                debugPrint('Dialog Dismiss from callback $type');
              },
              btnOkOnPress: () {
                dealService.put(deal);
                Navigator.pushNamed(context, RoutesDef.dashBoard);
              },
            ).show();
          },
        ),
      ],
      bottomSheet: BottomSheet(
          backgroundColor: CommonColors.background,
          dragHandleColor: CommonColors.background,
          shadowColor: CommonColors.dark,

          onClosing: () {

          },
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: SafeArea(
                child: Wrap(
                  runSpacing: 10,
                  children: [
                    Text("Totale speso : $totalePagato €"),
                    FAProgressBar(
                      currentValue: percentuale.roundToDouble(),
                      maxValue: 100,
                      size: 50,
                      displayText: ' %',
                      displayTextStyle: const TextStyle(fontFamily: 'bold'),
                      backgroundColor: CommonColors.primary,
                      progressColor: CommonColors.secondary ,
                    ),

                    Text("Introito totale previsto: $introitoPrevisto €"),

                  ],
                ),
              )
            );
          },
      ),
      body:  Padding(
       padding: const EdgeInsets.only(
         top: 10,
         right: 20,
         left: 20,
       ),
       child: ListView.separated(
         itemCount: deal.prodottiDeals.length,
         separatorBuilder: (context, index) => const SizedBox(height: 10),
         itemBuilder: (context, index) {
           DealProduct dealProduct = deal.prodottiDeals.elementAt(index);
           return DealListTile(
               title: dealProduct.product.target!.nomeProdotto,
               subtitle: '${dealProduct.importoInvestito.toString()} €',
           ).dealListTile;
         },
       )
      ),
    );
  }

  double calcolaTotalePagato(Deal deal){
    double totale = 0;
    
    deal.prodottiDeals.forEach((prodottoDeal) { 
      totale += prodottoDeal.importoInvestito;
    });
    
    return totale;
  }
  
  double calcolaIntroitoPrevisto(Deal deal){
    double introito = 0;

    deal.prodottiDeals.forEach((prodottoDeal) {
      introito += (prodottoDeal.prezzoDettaglio! * prodottoDeal.disponibilitaMercato);
    });

    return introito;
  }

}
