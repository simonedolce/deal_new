import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:omc/common_widget/button_style.dart';
import 'package:omc/common_widget/common_function.dart';
import 'package:omc/common_widget/common_widget.dart';
import 'package:omc/common_widget/number_stepper.dart';
import 'package:omc/model/prodotto_deal.dart';
import 'package:omc/model/prodotto_ordine.dart';
import 'package:omc/util/colors.dart';
import 'package:omc/util/costants.dart';
import 'package:omc/util/strings.dart';

class OrdineFromDeal extends StatefulWidget {
  const OrdineFromDeal({Key? key}) : super(key: key);

  @override
  State<OrdineFromDeal> createState() => _OrdineFromDealState();
}

class _OrdineFromDealState extends State<OrdineFromDeal> {
  final List<ProdottoOrdine> prodottiOrdine = [];
  final TextEditingController controllerImportoCliente    = TextEditingController();
  final TextEditingController controllerQuantitaRichiesta = TextEditingController();
  final TextEditingController controllerQuantitaEffettiva = TextEditingController();
  final CommonFunction commonFunction = CommonFunction();

  @override
  Widget build(BuildContext context) {
    BuildContext mainContext = context;
    final List<ProdottoDeal> prodottiDeals = ModalRoute.of(context)!.settings.arguments as List<ProdottoDeal>;
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.ordina),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.highlight,
          onPressed: _openCartModal, // Apri la modal del carrello
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_cart, size: 20),
              Text(prodottiOrdine.length.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontFamily:'bold',fontSize: 15),)
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: prodottiDeals.length,
                itemBuilder: (BuildContext context, int index) {
                  final ProdottoDeal prodottoDeal = prodottiDeals[index];
                  final isSelect = isSelected(prodottoDeal);
                  IconData icon = Icons.add;
                  if(isSelect){
                    icon = Icons.edit;
                  }else if(prodottoDeal.disponibilitaMercato <= 0){
                    icon = Icons.cancel;
                  }
                  return ListTile(
                    tileColor: isSelect ? AppColors.highlight : null,
                    selected: prodottoDeal.isEsaurito(),
                    selectedColor: AppColors.paragraph,
                    splashColor: prodottoDeal.isEsaurito() ? AppColors.secondary : AppColors.highlight,
                    leading: CircleAvatar(child: Text(prodottoDeal.prodotto.tipoProdotto.descrizione[0])),
                    title: Text(prodottoDeal.prodotto.nomeProdotto),
                    titleTextStyle: TextStyle(fontFamily:'bold',color: isSelect ? AppColors.background : null),
                    subtitleTextStyle:const TextStyle(fontFamily:'mediumItalic'),
                    subtitle: Text('${prodottoDeal.prezzoDettaglio}${Strings.currency}/${Strings.uMisura}'),
                    textColor: isSelect ? AppColors.background : null,
                    trailing: Icon(icon),
                    onTap: () {
                      if(prodottoDeal.disponibilitaMercato > 0){
                        if(isSelect) {
                          ProdottoOrdine pOrdineSelected = findFromProdottoDeal(prodottoDeal);
                          showDialogPOrdine(mainContext,pOrdineSelected.quantitativoPrevisto, pOrdineSelected.quantitativoEffettivo, pOrdineSelected.prodottoDeal.disponibilitaMercato,pOrdineSelected);
                        } else {
                          double valoreIniziale = 0;
                          if(prodottoDeal.disponibilitaMercato > 1){
                            valoreIniziale = 1;
                          } else {
                            valoreIniziale = prodottoDeal.disponibilitaMercato;
                          }
                          showDialogPOrdine(mainContext,valoreIniziale, valoreIniziale, prodottoDeal.disponibilitaMercato, prodottoDeal);
                        }
                      } else {
                        commonFunction.showToast(Strings.prodottoEsaurito);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  double calcolaCostoPOrdine(ProdottoOrdine prodottoOrdine){
    ProdottoDeal prodottoDeal = prodottoOrdine.prodottoDeal;
    return prodottoDeal.prezzoDettaglio * prodottoOrdine.quantitativoPrevisto;
  }

  Iterable<ProdottoOrdine> getFilterFromDeal(ProdottoDeal prodottoDeal){
    return prodottiOrdine.where((pOrdine) => pOrdine.prodottoDeal.id == prodottoDeal.id);
  }

  ProdottoOrdine findFromProdottoDeal(ProdottoDeal prodottoDeal){
    Iterable<ProdottoOrdine> pFilter = getFilterFromDeal(prodottoDeal);
    return pFilter.first;
  }

  bool isSelected(ProdottoDeal prodottoDeal){
    Iterable<ProdottoOrdine> pFilter = getFilterFromDeal(prodottoDeal);
    return pFilter.isNotEmpty;
  }

  void editPOrder(ProdottoOrdine pOrdine, String qPrevistoVal,String qEffettivoVal){
    double quantitativoPrevisto = double.parse(qPrevistoVal);
    double quantitativoEffettivo = double.parse(qEffettivoVal);

    prodottiOrdine.remove(pOrdine);

    if(quantitativoPrevisto == 0 && quantitativoEffettivo == 0){
      return;
    }

    pOrdine.quantitativoPrevisto = double.parse(qPrevistoVal);
    pOrdine.quantitativoEffettivo = double.parse(qEffettivoVal);
    prodottiOrdine.add(pOrdine);
  }

  void showDialogPOrdine(BuildContext mainContext ,double qPrevistoVal , double qEffettivoVal, double maxValue,  Object object){
    double importoIniziale = 0;
    double prezzoDettaglio = 0;
    double disponibilitaMassima = 0;
    
    if(object is ProdottoDeal){
      prezzoDettaglio = object.prezzoDettaglio;
      disponibilitaMassima = object.disponibilitaMercato;
    } else if(object is ProdottoOrdine) {
      prezzoDettaglio = object.prodottoDeal.prezzoDettaglio;
      disponibilitaMassima = object.prodottoDeal.disponibilitaMercato;
    }

    importoIniziale = qPrevistoVal * prezzoDettaglio;

    showDialog(
      context: mainContext,
      builder: (BuildContext context) {

        return AlertDialog(
          title: Text("${Strings.quantita} ($prezzoDettaglio ${Strings.currency} / ${Strings.uMisura})"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Importo:'),
              CommonWidget().incDecInput(
                  controllerImportoCliente,
                  importoIniziale,
                  maxValue: disponibilitaMassima * prezzoDettaglio,
                  incDecFactor: 1,
                  onChangedFunct : (changedValue) {
                    String value = (changedValue / prezzoDettaglio).toStringAsFixed(2);
                    controllerQuantitaRichiesta.text = value;
                    controllerQuantitaEffettiva.text = value;

                  },
                  onIncrementFunct: (incrementedValue){
                    setState(() {
                      String value = (incrementedValue / prezzoDettaglio).toStringAsFixed(2);
                      controllerQuantitaRichiesta.text = value;
                      controllerQuantitaEffettiva.text = value;
                    });
                  },
                  onDecrement: (decrementedValue){
                    setState(() {
                      String value = (decrementedValue / prezzoDettaglio).toStringAsFixed(2);
                      controllerQuantitaRichiesta.text = value;
                      controllerQuantitaEffettiva.text = value;
                    });
                  },
              ),
              const Text('Quantitativo Richiesto:'),
              CommonWidget().incDecInput(
                  controllerQuantitaRichiesta,
                  qPrevistoVal,
                  minValue: 0,
                  maxValue: disponibilitaMassima,
                  onChangedFunct : (changedValue){
                    controllerQuantitaEffettiva.text = changedValue.toStringAsFixed(2);
                    controllerImportoCliente.text = (changedValue * prezzoDettaglio).toStringAsFixed(2);
                  },
                  onIncrementFunct: (incrementedValue){
                    setState(() {
                      controllerQuantitaEffettiva.text = incrementedValue.toStringAsFixed(2);
                      controllerImportoCliente.text = (incrementedValue * prezzoDettaglio).toStringAsFixed(2);
                    });
                  },
                  onDecrement: (decrementedValue){
                    setState(() {
                      controllerQuantitaEffettiva.text = decrementedValue.toStringAsFixed(2);
                      controllerImportoCliente.text = (decrementedValue * prezzoDettaglio).toStringAsFixed(2);
                    });
                  },
              ),
              const Text('Quantitativo Effettivo:'),
              CommonWidget().incDecInput(
                controllerQuantitaEffettiva,
                qEffettivoVal,
                minValue: 0,
                maxValue: disponibilitaMassima,
              )
            ],
          ),
          actions: [
            OutlinedButton(
              style: CustomButtonStyle.outlinedButton,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Chiudi'),
            ),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColors.highlight)),
              onPressed: () {
                setState(() {
                  if(object is ProdottoOrdine){
                    editPOrder(object, controllerQuantitaRichiesta.text, controllerQuantitaEffettiva.text);
                  } else if(object is ProdottoDeal){
                    add(object, qPrevistoVal, qEffettivoVal);
                  }
                });

                Navigator.of(context).pop();
              },
              child: const Text('Conferma'),
            ),
          ],
        );
      },
    );
  }

  void add(ProdottoDeal prodottoDeal, double qPrevisto, double qEffettivo) {
    double quantitativoRichiesto = double.parse(controllerQuantitaRichiesta.text);
    double quantitativoEffettivo = double.parse(controllerQuantitaEffettiva.text);
    if(quantitativoRichiesto == 0 && quantitativoEffettivo == 0 ){
      return;
    }
    ProdottoOrdine newPo = ProdottoOrdine(
      0,
      quantitativoEffettivo,
      quantitativoRichiesto,
      prodottoDeal,
    );

    bool isInList = false;

    for (ProdottoOrdine prod in prodottiOrdine) {
      isInList = prod.prodottoDeal.id == prodottoDeal.id;
      if (isInList) {
        newPo = prod;
        break;
      }
    }

    setState(() {
      if (isInList) {
        prodottiOrdine.remove(newPo);
      } else {
        prodottiOrdine.add(newPo);
      }
    });
  }

  void _openCartModal() {
    prodottiOrdine.isNotEmpty ?
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Carrello'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.maxFinite,
                height: 200, // Imposta l'altezza della modal in base alle tue esigenze
                child: ListView.builder(
                  itemCount: prodottiOrdine.length,
                  itemBuilder: (BuildContext context, int index) {
                    final ProdottoOrdine pOrdine = prodottiOrdine[index];
                    return ListTile(
                      title: Text(pOrdine.prodottoDeal.prodotto.nomeProdotto),
                      subtitle: Text('Quantità: ${pOrdine.quantitativoPrevisto}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            prodottiOrdine.remove(pOrdine);
                          });
                          _openCartModal();
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16), // Spazio vuoto tra la ListView e il testo
              Text(
                'Totale dovuto: ${CommonFunction().calcolaTotaleDovuto(prodottiOrdine)} ${Strings.currency}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Chiudi'),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/riepilogoOrdine', arguments: prodottiOrdine);
              },
              style: CustomButtonStyle.outlinedButton,
              child: const Text('Conferma'),
            )
          ],
        );
      },
    ) : commonFunction.showToast(Strings.errCarrelloVuoto);
  }



}
