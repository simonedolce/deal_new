import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:omc/common_widget/common_function.dart';
import 'package:omc/common_widget/common_widget.dart';
import 'package:omc/common_widget/input_field.dart';
import 'package:omc/model/deal.dart';
import 'package:omc/model/prodotto_deal.dart';
import 'package:omc/util/colors.dart';
import 'common_widget/animated_dialog.dart';
import 'common_widget/button_style.dart';
import 'common_widget/hero_card.dart';
import 'model/prodotto.dart';
import 'model/tipo_prodotto.dart';
import 'util/strings.dart';

class AggiungiDeal extends StatefulWidget {
  const AggiungiDeal({Key? key}) : super(key: key);


  @override
  State<AggiungiDeal> createState() => _AggiungiDealState();
}



class _AggiungiDealState extends State<AggiungiDeal> {

  List<Prodotto> _prodottiList = [];
  List<ProdottoDeal> _prodottiDealList = [];
  List<TipoProdotto> tipoProdottoList = [];
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    getProdottiList();
    getTipiProdotti();
  }

  Future<void> getTipiProdotti() async {
    const platform = MethodChannel('com.example.omc/crea_prodotto');
    List<dynamic> serializedList = await platform.invokeMethod('get_all_tipo_prodotto');
    List<TipoProdotto> updatedList = [];

    for (String json in serializedList) {
      final tipoProdotto = TipoProdotto.fromJson(jsonDecode(json));
      updatedList.add(tipoProdotto);
    }
    tipoProdottoList = updatedList;


  }

  Future<void> confermaDeal(Deal deal) async {// La tua lista di oggetti
    Map<String, dynamic> serialized = deal.toJson() ;

    const platform = MethodChannel('com.example.omc/deal');

    try {
      await platform.invokeMethod('insert_deal', {'jsonString': jsonEncode(serialized)});
    } catch (e) {
      print('Errore durante la chiamata del metodo Java: $e');
    }
  }

  void setProdottiDealInList(ProdottoDeal prodottoDeal){
    setState(() {
      _prodottiDealList.add(prodottoDeal);
    });
  }

  double calcolaPercentuale(){
    double rientro = rientroPrevisto();
    double spesa = totaleSpeso();
    return (rientro / spesa) * 100;

  }
  double totaleQuantitaMercato(){
    double quantitaMercato = 0;
    for (var prodottoDeal in _prodottiDealList) {
       quantitaMercato += (prodottoDeal.quantitativoProdottoDeal - prodottoDeal.disponibilitaPersonale);
    }
    return quantitaMercato;
  }
  double rientroPrevisto(){
    double rientro = 0;
    for (var prodottoDeal in _prodottiDealList) {
      double quantitaMercato = prodottoDeal.quantitativoProdottoDeal - prodottoDeal.disponibilitaPersonale;
      rientro += prodottoDeal.prezzoDettaglio * quantitaMercato;
    }
    return rientro;
  }

  double totalePersonale(){
    double personale = 0;
    for (var prodottoDeal in _prodottiDealList) {
      personale += prodottoDeal.disponibilitaPersonale;
    }
    return personale;
  }

  double totaleAcquistato(){
    double acquistato = 0;
    for (var prodottoDeal in _prodottiDealList) {
      acquistato += prodottoDeal.quantitativoProdottoDeal;
    }
    return acquistato;
  }

  double totaleSpeso(){
    double totaleSpeso = 0;
    for (var prodottoDeal in _prodottiDealList) {
      totaleSpeso += prodottoDeal.prezzoIngrosso * prodottoDeal.quantitativoProdottoDeal;
    }
    return totaleSpeso;
  }

  void getProdottiList() async {
    const platform = MethodChannel('com.example.omc/crea_prodotto');
    List<dynamic> serializedList = await platform.invokeMethod('get_all_prodotti');
    List<Prodotto> updatedList = [];

    for (String json in serializedList) {
      final prodotto = Prodotto.fromJson(jsonDecode(json));
      updatedList.add(prodotto);
    }


    setState(() {
      _prodottiList = updatedList;
    });
}
  final TextEditingController _quantitativoProdottoDealController = TextEditingController();
  final TextEditingController _disponibilitaPersonaleController = TextEditingController();
  final TextEditingController _prezzoDiCostoController = TextEditingController();
  final TextEditingController _prezzoDettaglioController = TextEditingController();
  final TextEditingController _nomeInputFieldController = TextEditingController();

  CommonFunction commonFunction = CommonFunction();
  TipoProdotto? tipoProdottoSelezionato;


  @override
  Widget build(BuildContext context) {

    final GlobalKey<FormState> _key = GlobalKey<FormState>();
    GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
    final _keyFab = GlobalKey<ExpandableFabState>();
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        floatingActionButton: ExpandableFab(
          initialOpen: false,
          key: _key,
          duration: const Duration(milliseconds: 500),
          distance: 100.0,
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
            angle: 3.14 * 5,
          ),
          closeButtonBuilder: FloatingActionButtonBuilder(
            size: 56,
            builder: (BuildContext context, void Function()? onPressed,
                Animation<double> progress) {
              return IconButton(
                onPressed: onPressed,
                icon: const Icon(
                  Icons.close_rounded,
                  color: AppColors.highlight,
                  size: 40,
                ),
              );
            },
          ),
          overlayStyle: ExpandableFabOverlayStyle(
            // color: Colors.black.withOpacity(0.5),
            blur: 5,
          ),
          children: [
            FloatingActionButton.extended(
              onPressed: () {
                if(_prodottiList.isNotEmpty){
                  visualizzaListaProdottiAcquistabili(context);
                } else {
                  commonFunction.showToast(Strings.nessunProdottoPresente);
                }
              },
              backgroundColor: _prodottiList.isNotEmpty ? AppColors.highlight : AppColors.paragraph,
              label: const Text('Aggiungi Prodotto Al Deal'),
              icon: Icon(_prodottiList.isNotEmpty ? Icons.add_box_rounded : Icons.cancel),
            ),
            FloatingActionButton.extended(
              onPressed: () {
                //Navigator.pop(context);
                //Navigator.pushNamed(context, '/creaProdotto');
                showDialog(
                    context: context,
                    builder: (BuildContext dialogContext){

                      return AnimatedDialog(
                          title: Strings.creaProdotto,
                          widgets: [
                            Form(
                              key: _key,
                              child: Column(
                                children: [
                                  InputField(label: Strings.nomeProdotto,controller: _nomeInputFieldController, obscure: false),
                                  DropdownButton<TipoProdotto>(
                                    value: tipoProdottoSelezionato,
                                    items: tipoProdottoList.map((TipoProdotto option) {
                                      return DropdownMenuItem<TipoProdotto>(
                                        value: option,
                                        child: Text(option.descrizione),
                                      );
                                    }).toList(),
                                    onChanged: (val){
                                      setState(() {
                                        tipoProdottoSelezionato = val!;
                                      });
                                    },
                                  )

                                  //Wrap(
                                  //  spacing: 5.0,
                                  //  children: tipoProdottoList.map((tipoProdotto) {
                                  //    return ChoiceChip(
                                  //      label: Text(tipoProdotto.descrizione),
                                  //      selected: _valTipoProdottoChips == tipoProdotto.id,
                                  //      onSelected: (bool selected) {
                                  //        setState(() {
                                  //          _valTipoProdottoChips = selected ? tipoProdotto.id : null;
                                  //        });
                                  //      },
                                  //    );
                                  //  }).toList(),
                                  //),
                                ],
                              ),
                            ),
                          ]
                      );
                    }
                );


              },
              backgroundColor: AppColors.highlight,
              label: const Text(Strings.creaProdotto),
              icon: const Icon(Icons.add_box_rounded),
            ),
          ],
        ),
        appBar: CommonFunction().customAppBar(Strings.aggiungiDeal),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 26),
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: (){
                    if(_prodottiDealList.isNotEmpty){
                      CommonFunction().showAnimatedDialog(
                          context,
                          Strings.completaOrdineMessage,
                          [
                            rowInfoDeal(Strings.totaleSpeso, totaleSpeso().toString() + Strings.currency),
                            const SizedBox(height: 13),
                            rowInfoDeal(Strings.totaleAcquistato, totaleAcquistato().toString() + Strings.uMisura),
                            const SizedBox(height: 13),
                            rowInfoDeal(Strings.totalePersonale, totalePersonale().toString() + Strings.uMisura),
                            const SizedBox(height: 13),
                            ElevatedButton(
                              onPressed: (){
                                Deal deal = Deal(0, rientroPrevisto(), 0, 0, 0, 0, 0, 0, 0, _prodottiDealList, 0);
                                confermaDeal(deal);
                                Navigator.popAndPushNamed(context,'/homePage');
                              },
                              style: CustomButtonStyle.elevatedButton,
                              child: const Text(Strings.conferma),
                            )
                          ]
                      );

                    } else {
                      CommonFunction().showToast("Prima compra qualcosa no? Pizzarrone");
                    }
                  },
                  style: _prodottiDealList.isNotEmpty ? CustomButtonStyle.elevatedButton : ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColors.paragraph)),
                  child: const Text(Strings.completaOrdine, style: TextStyle(fontFamily: 'medium', color: AppColors.background))
              ),
              const Divider(thickness: 1,color: AppColors.highlight),
              const SizedBox(height: 26),
              Column(
                children: [
                  const Text('Percentuale', style: TextStyle(fontFamily: 'medium'),),
                  const SizedBox(height: 13),
                  CommonWidget().progressBarPercentuale(
                      calcolaPercentuale(),
                      '${rientroPrevisto()}${Strings.currency}'
                  )
                ],
              ),
              const SizedBox(height: 26),
              Expanded(
                  child: _prodottiDealList.isEmpty ? Text(Strings.aggiungiProdottoDeal, style: TextStyle(fontFamily: 'medium')) :
                  ListView.builder(
                  itemCount: _prodottiDealList.length,
                  itemBuilder: (context, index) {
                    ProdottoDeal prodottoDeal = _prodottiDealList[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(height: 16.0),
                        ListTile(
                          title: Text('${prodottoDeal.prodotto.nomeProdotto}: ${prodottoDeal.quantitativoProdottoDeal} gr.'),
                          subtitle: const Text(Strings.deleteFromLongPress , style: TextStyle(fontFamily: 'mediumItalic', fontSize: 10)),
                          onLongPress:() {
                            setState(() {
                            _prodottiDealList.remove(_prodottiDealList[index]);
                            });
                          },
                          leading: const CircleAvatar(
                              backgroundColor: AppColors.highlight,
                              child: Icon(Icons.shopping_cart , size: 20),
                          ),
                        ),
                      ],
                    );
                  }
                )
              ),
            ],
          ),
        )
      ),
    );
  }

  void visualizzaListaProdottiAcquistabili(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AnimatedDialog(
              title: 'Scegli un prodotto da acquistare',
              widgets: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _prodottiList.length,
                    itemBuilder: (context, index) {
                      final Prodotto prodotto = _prodottiList[index];
                      return ListTile(
                        title: Text(prodotto.nomeProdotto),
                        subtitle: Text(prodotto.tipoProdotto.descrizione),
                        leading: CircleAvatar(
                          backgroundColor: AppColors.highlight,
                          child: Text(prodotto.nomeProdotto[0]),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.add_box_rounded),
                          color: AppColors.highlight,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AnimatedDialog(
                                    title: '${Strings.acquista} : ${prodotto.nomeProdotto}',
                                    widgets: [
                                      Form(
                                          key: _key,
                                          child: Column(
                                            children: [
                                              InputField(label: Strings.quantitativoProdottoDeal, obscure: false, controller: _quantitativoProdottoDealController,integer: true),
                                              InputField(label: Strings.disponibilitaPersonale, obscure: false, controller: _disponibilitaPersonaleController,integer: true,
                                                validatorFunc: (value) =>
                                                    usoPersonaleValidator(
                                                        value!,
                                                        _quantitativoProdottoDealController.text
                                                    ),
                                              ),
                                              InputField(label: Strings.prezzoDiCosto, obscure: false, controller: _prezzoDiCostoController,integer: true),
                                              InputField(label: Strings.prezzoDettaglio, obscure: false, controller: _prezzoDettaglioController,integer: true,
                                                validatorFunc: (value) =>
                                                    prezzoAlMercatoValidator(value!, _prezzoDiCostoController.text),
                                              ),
                                              Row(
                                                children: [
                                                  OutlinedButton(
                                                    onPressed: (){
                                                      if(_key.currentState!.validate()){
                                                        double quantitativoProdottoDeal = double.tryParse(_quantitativoProdottoDealController.text)!;
                                                        double disponibilitaPersonale = double.tryParse(_disponibilitaPersonaleController.text)!;
                                                        double prezzoDiCosto = double.tryParse(_prezzoDiCostoController.text)!;
                                                        double prezzoDettaglio = double.tryParse(_prezzoDettaglioController.text)!;
                                                        _prezzoDettaglioController.clear();
                                                        _prezzoDiCostoController.clear();
                                                        _disponibilitaPersonaleController.clear();
                                                        _quantitativoProdottoDealController.clear();
                                                        ProdottoDeal prodottoDeal = ProdottoDeal(
                                                            0,
                                                            prodotto,
                                                            quantitativoProdottoDeal,
                                                            disponibilitaPersonale,
                                                            quantitativoProdottoDeal - disponibilitaPersonale,
                                                            quantitativoProdottoDeal,
                                                            quantitativoProdottoDeal- disponibilitaPersonale,
                                                            disponibilitaPersonale,
                                                            prezzoDiCosto,
                                                            prezzoDettaglio,
                                                            quantitativoProdottoDeal * prezzoDiCosto,
                                                            0
                                                        );
                                                        setProdottiDealInList(prodottoDeal);
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    style: CustomButtonStyle.outlinedButton,
                                                    child: const Text(Strings.conferma),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )
                                      )

                                    ]
                                );
                              },
                            );


                          },
                        ),
                      );
                    },
                  ),
                )
              ]
          );
        },
    );
  }

  String? prezzoAlMercatoValidator(String prezzoAlMercato, String prezzoDiCosto) {
    double? prezzoAlMercatoDouble = double.tryParse(prezzoAlMercato);
    double? prezzoDiCostoDouble = double.tryParse(prezzoDiCosto);

    if(prezzoDiCostoDouble == null){
      return Strings.required;
    }

    if(prezzoAlMercatoDouble! <= prezzoDiCostoDouble){
      return Strings.prezzoAlMercatoValidator;
    }

    return null;
  }



  String? usoPersonaleValidator(String value, String primaryValue) {
    double? usoPersonale = double.tryParse(value);
    double? quantitaAcquistata = double.tryParse(primaryValue);

    if(usoPersonale == null){
       return Strings.required;
    }

    if(usoPersonale > quantitaAcquistata!){
       return Strings.usoPValidator;
    }
    return null;
  }

  Widget rowInfoDeal(String titolo, String parametro){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
            style: const TextStyle(fontFamily: 'regular', fontSize: 18),
            titolo
        ),
        const SizedBox(width: 10),
        Text(
            parametro,
            style: const TextStyle(fontFamily: 'bold', fontSize: 18),
        ),
      ],
    );
  }

}

