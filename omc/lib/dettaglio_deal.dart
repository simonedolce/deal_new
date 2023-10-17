import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:omc/common_widget/button_style.dart';
import 'package:omc/model/prodotto_deal.dart';
import 'package:omc/util/colors.dart';
import 'package:omc/util/strings.dart';


import 'common_widget/card.dart';
import 'common_widget/common_function.dart';
import 'model/deal.dart';

class DettaglioDeal extends StatefulWidget {


  const DettaglioDeal({super.key});

  @override
  State<DettaglioDeal> createState() => _DettaglioDealState();
}
enum Sizes { extraSmall, small, medium, large, extraLarge }

class _DettaglioDealState extends State<DettaglioDeal> {
  @override
  void initState() {
    super.initState();
  }

  void returnDeal(){

  }


  @override
  Widget build(BuildContext context) {
    final Deal deal = ModalRoute.of(context)!.settings.arguments as Deal;
    final _key = GlobalKey<ExpandableFabState>();
    List<Deal> fakeList = [];
    fakeList.add(deal);
    Map<String, String> rows = {
      Strings.totaleSpeso: CommonFunction().calcolaTotaleSpeso(fakeList).toString() + Strings.currency,
      Strings.totaleRientrato: CommonFunction().calcolaTotaleRientrato(fakeList).toString() + Strings.currency,
    };

    SimpleTable sTable = SimpleTable(rows: rows);


    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: CommonFunction().customAppBar(Strings.dettaglioDeal + deal.id.toString()),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: ExpandableFab(
          key: _key,
          duration: const Duration(milliseconds: 250),
          distance: 75.0,
          type: ExpandableFabType.up,
          pos: ExpandableFabPos.right,
          childrenOffset: const Offset(0, 20),
          fanAngle: 40,
          openButtonBuilder: RotateFloatingActionButtonBuilder(
            child: const Icon(Icons.list),
            fabSize: ExpandableFabSize.regular,
            foregroundColor: AppColors.background,
            backgroundColor: AppColors.highlight,
            shape: const CircleBorder(),
            angle: 3.14 * 10,
          ),
          closeButtonBuilder: FloatingActionButtonBuilder(
            size: 56,
            builder: (BuildContext context, void Function()? onPressed,
                Animation<double> progress) {
              return IconButton(
                onPressed: onPressed,
                icon: const Icon(
                  Icons.cancel,
                  color: AppColors.highlight,
                  size: 40,
                ),
              );
            },
          ),
          overlayStyle: ExpandableFabOverlayStyle(
            //color: Colors.black.withOpacity(0.5),
            blur: 5,
          ),
          children: [
            FloatingActionButton.extended(
              // shape: const CircleBorder(),
              heroTag: null,
              backgroundColor: deal.disponibilitaTotaleMercato > 0 ? AppColors.highlight : AppColors.paragraph,
              label: const Text(style: TextStyle(fontFamily: 'medium'),'Acquista'),
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                if(deal.disponibilitaTotaleMercato > 0){
                  Navigator.pushNamed(context, '/ordine', arguments: deal.prodottiDeals);
                } else {
                  CommonFunction().showToast(Strings.prodottiEsauriti);
                }
              },
            ),
            FloatingActionButton.extended(
              // shape: const CircleBorder(),
              heroTag: null,
              backgroundColor: AppColors.highlight,
              label: const Text(style: TextStyle(fontFamily: 'medium'),'Modifica Prodotti'),
              icon: const Icon(Icons.edit),
              onPressed: () {
                final state = _key.currentState;
                if (state != null) {
                  _openListProdottiDeal(context,deal);
                  debugPrint('isOpen:${state.isOpen}');
                  state.toggle();
                }
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start, // Allinea l'avatar in cima
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.highlight,
                    child: Text(deal.id.toString(), style: const TextStyle(fontSize: 40),),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        deal.formatDate().toString(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        deal.prodottiDeals.length > 1 ? '${deal.prodottiDeals.length} prodotti disponibili' : '${deal.prodottiDeals.length} prodotto disponibile',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 26),
              Expanded(child: sTable.build(context)),
            ],
          )
        ),
      ),
    );
    

  }
}

Widget returnText(String text , double size){
  return
    Text(
      text,
      style: TextStyle(fontSize: size),
    );

}

Widget createRow(List<Widget> widgets){
  return  Row(
        children: [
          if (widgets != null) ...widgets,
        ],
      );
}

void _openListProdottiDeal(BuildContext context, Deal deal) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(Strings.elencoProdottiDeal),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.maxFinite,
              height: 200, // Imposta l'altezza della modal in base alle tue esigenze
              child: ListView.builder(
                itemCount: deal.prodottiDeals.length,
                itemBuilder: (BuildContext context, int index) {
                  final ProdottoDeal pDeal = deal.prodottiDeals[index];
                  return ListTile(
                    title: Text(pDeal.prodotto.nomeProdotto),
                    subtitle: Text(pDeal.prezzoDettaglio.toString() + Strings.currency),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/editPDeal', arguments: pDeal);


                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16), // Spazio vuoto tra la ListView e il testo

          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(Strings.annulla),
          ),
          OutlinedButton(
            onPressed: () {},
            style: CustomButtonStyle.outlinedButton,
            child: const Text(Strings.conferma),
          )
        ],
      );
    },
  );
}


