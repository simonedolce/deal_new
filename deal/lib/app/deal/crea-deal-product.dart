import 'package:deal/model/deal-product.dart';
import 'package:deal/util/colors.dart';
import 'package:deal/util/deal-input-decorator.dart';
import 'package:deal/util/deal-styles.dart';
import 'package:deal/util/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/deal.dart';

class CreaDealProduct extends StatefulWidget {
  final Deal deal;
  const CreaDealProduct({super.key, required this.deal});

  @override
  State<CreaDealProduct> createState() => _CreaDealProductState();
}

class _CreaDealProductState extends State<CreaDealProduct> {
  final GlobalKey<FormState> _keyFormDealProducts = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  Map<DealProduct,Map<String, TextEditingController>> dealProdControllerMap = {};

  @override
  Widget build(BuildContext context) {
    Deal deal = widget.deal;

    for (var element in deal.prodottiDeals) {
      final TextEditingController _quantitativoProdottoDealController = TextEditingController();
      final TextEditingController _disponibilitaPersonaleController = TextEditingController();
      final TextEditingController _prezzoDiCostoController = TextEditingController();
      final TextEditingController _prezzoDettaglioController = TextEditingController();

      Map<String,TextEditingController> controllersMap = {};

      controllersMap['quantitativoProdottoDealController'] = _quantitativoProdottoDealController;
      controllersMap['disponibilitaPersonaleController'] = _disponibilitaPersonaleController;
      controllersMap['prezzoDiCostoController'] = _prezzoDiCostoController;
      controllersMap['prezzoDettaglioController'] = _prezzoDettaglioController;
      dealProdControllerMap[element] = controllersMap;


    }

    return Scaffold(
      appBar: AppBar(backgroundColor: CommonColors.background,title: Text("'Completa l'acquisto" , style: TextStyle(fontFamily: 'mosteraRegular'))),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          right: 20,
          left: 20,
        ),
        child: Form(
          key: _keyFormDealProducts,
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemCount: dealProdControllerMap.length,
            itemBuilder: (BuildContext context, int index) {
              DealProduct dealProduct = deal.prodottiDeals.elementAt(index);
              Map<String, TextEditingController>? controllers = dealProdControllerMap[dealProduct];

              return ExpansionTile(
                title: Text(dealProduct.product.target!.nomeProdotto, style: const TextStyle(fontFamily: 'bold', color: CommonColors.dirtyWhite)),
                subtitle: Text(dealProduct.product.target!.productType.target!.descrizione,style: const TextStyle(color: CommonColors.dirtyWhite)),
                leading: const Icon(Icons.error),
                maintainState: true,
                backgroundColor: CommonColors.secondary,
                collapsedBackgroundColor: CommonColors.primary,
                collapsedShape: DealStyles.roundRectangleRadiusBorder,
                shape: DealStyles.roundRectangleRadiusBorder,
                childrenPadding: const EdgeInsets.all(20),
                children: [
                  Wrap(
                    runSpacing: 10,
                    children: [
                      TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: DealInputDecorator(label: 'Quantità').dealInputDecorator,
                          controller: controllers?['quantitativoProdottoDealController'],
                          validator: (value) => required(value!)
                      ),
                      TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: DealInputDecorator(label: 'Quantitativo personale').dealInputDecorator,
                          controller: controllers?['disponibilitaPersonaleController'],
                          validator: (value) => required(value!)
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                          decoration: DealInputDecorator(label: 'Prezzo di costo').dealInputDecorator,
                          controller: controllers?['prezzoDiCostoController'],
                          validator: (value) => validatorPrezzi(value!, controllers!['prezzoDettaglioController']!.text),
                      ),
                      TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: DealInputDecorator(label: 'Prezzo al dettaglio').dealInputDecorator,
                          controller: controllers?['prezzoDettaglioController'],
                          validator: (value) => required(value!)
                      ),
                    ],
                  )

                ]
                ,
              );
            },

          ),
        )

      ),
      persistentFooterButtons: [
        ElevatedButton(onPressed: (){

          if(_keyFormDealProducts.currentState!.validate()){
            settaProdottiDeal(deal);
            Navigator.pushNamed(context, RoutesDef.confermaDeal,arguments:  {'deal' : deal});
          }

        }, child: const Text("Continua")),
      ],
    );
  }

  void settaProdottiDeal(Deal deal){
    dealProdControllerMap.forEach((dealProduct, valori) {
      dealProduct.deal.target = deal;
      dealProduct.disponibilitaPersonale = double.parse(valori['disponibilitaPersonaleController']!.text);
      dealProduct.disponibilitaMercato = double.parse(valori['quantitativoProdottoDealController']!.text) - dealProduct.disponibilitaPersonale;
      dealProduct.prezzoIngrosso = double.parse(valori['prezzoDiCostoController']!.text);
      dealProduct.prezzoDettaglio = double.parse(valori['prezzoDettaglioController']!.text);
      dealProduct.importoRientrato = 0;
      dealProduct.importoInvestito = (dealProduct.disponibilitaMercato! + dealProduct.disponibilitaPersonale) * dealProduct.prezzoIngrosso;
    });
  }

  String? validatorPrezzi(String prezzoCosto, String prezzoDettaglio){
    String? emptyError = required(prezzoCosto);
    if(emptyError == null){
      double prezzoC = double.parse(prezzoCosto);
      double prezzoD = double.parse(prezzoDettaglio);
      if(prezzoC >= prezzoD){
        return "Il prezzo di costo deve essere minore del prezzo di dettaglio";
      }
    } else {
      return emptyError;
    }

    return null;
  }
  String? validatorQuantita(String quantitaPersonale, String quantitaTotale){
    String? emptyError = required(quantitaPersonale);
    if(emptyError == null){
      double quantitaP = double.parse(quantitaPersonale);
      double quantitaT = double.parse(quantitaTotale);
      if(quantitaP > quantitaT){
        return "La quantità personale non può essere più alta della quantità totale";
      }
    } else {
      return emptyError;
    }

    return null;
  }

  String? required(String value){
    if(value.isEmpty){
      return "Il valore è obbligatorio";
    }
    return null;
  }
}
