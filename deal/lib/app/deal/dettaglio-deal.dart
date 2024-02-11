import 'package:deal/model/deal-product.dart';
import 'package:deal/util/deal-styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import '../../model/deal.dart';
import '../../util/colors.dart';
import '../../util/text-styles.dart';

class DettaglioDeal extends StatefulWidget {
  final Deal deal;
  const DettaglioDeal({super.key, required this.deal});

  @override
  State<DettaglioDeal> createState() => _DettaglioDealState();
}

class _DettaglioDealState extends State<DettaglioDeal> {
  late Deal deal;
  late double percentuale;
  late String statusText;
  late String rapporto;

  late double totaleRientrato;
  late double totaleInvestito;
  late bool inGuadagno;


  String getStatusText(){
    String status = '';

    if(percentuale <= 25) {
      status = 'Diamoci da fare!';
    }

    if(percentuale >= 25 && percentuale <= 50) {
      status = "Qualcosa si muove!";
    }

    if(percentuale >= 50 && percentuale <= 75) {
      status = "Sei a metà dell'opera";
    }

    if(percentuale >= 75 && percentuale <= 100) {
      status = "Ci siamo quasi !";
    }

    if(percentuale >= 100) {
      status = "Stai guadagnando!";
    }

    return status;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deal = widget.deal;
    totaleRientrato = deal.getTotaleImportoRientrato();
    totaleInvestito = deal.getTotaleImportoInvestito();

    percentuale = (totaleRientrato / totaleInvestito) * 100;
    statusText = getStatusText();
    rapporto = "${totaleRientrato.round()} € / ${totaleInvestito.round()} €";
    inGuadagno = totaleRientrato > totaleInvestito;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Deal numero ${deal.id}',style: DealTextStyles(fontName: 'mosteraRegular').textStyleDark),backgroundColor: CommonColors.background),
      body: SafeArea(
        child: Padding (
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Data : ${deal.getDataCreazione()}', style: DealTextStyles(fontSize: 16).textStyleDark),
                  Text('Prodotti disponibili : ${deal.prodottiDeals.length}', style: DealTextStyles(fontSize: 16).textStyleDark),

                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration:  BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: CommonColors.primary,
                  border: Border.all(
                      color: CommonColors.dark
                  ),
                ),


                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(statusText, style: DealTextStyles(fontSize: 25).textStyleDark),
                    const SizedBox(height: 2),
                    Text(rapporto, style: DealTextStyles(fontSize: 16).textStyleDark),
                    const SizedBox(height: 12),
                    if(inGuadagno) Text('Totale guadagno: ${ deal.getTotaleGuadagno()} €',style: DealTextStyles(fontSize: 16).textStyleDark),
                    if(inGuadagno) const SizedBox(height: 10),
                    FAProgressBar(
                      currentValue: percentuale.roundToDouble(),
                      maxValue: 100,
                      size: 50,
                      displayText: ' %',
                      displayTextStyle: const TextStyle(fontFamily: 'bold'),
                      backgroundColor: CommonColors.primary,
                      progressColor: CommonColors.secondary ,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: deal.prodottiDeals.length,
                  itemBuilder: (context, index) {
                    DealProduct dealProduct = deal.prodottiDeals.elementAt(index);
                    return ListTile(
                      title: Text(dealProduct.product.target!.nomeProdotto),
                      subtitle: Text('${dealProduct.prezzoIngrosso} €'),
                      shape: DealStyles.roundRectangleRadiusBorder,
                      tileColor: CommonColors.primary,
                    );
                  }, separatorBuilder: (BuildContext context, int index) { return const SizedBox(height: 10); },

                ),

              ),
            ],

          ),
        ),
      )
    );
  }
}
