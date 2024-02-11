import 'package:animated_digit/animated_digit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:deal/model/deal.dart';
import 'package:deal/model/order-product.dart';
import 'package:deal/util/colors.dart';
import 'package:deal/util/deal-button-styles.dart';

import 'package:deal/util/deal-styles.dart';
import 'package:deal/util/routes.dart';
import 'package:flutter/material.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

import '../../model/deal-product.dart';
import '../../model/order.dart';

class AcquistoQuantita extends StatefulWidget {
  final List<DealProduct> list;
  const AcquistoQuantita({super.key, required this.list});

  @override
  State<AcquistoQuantita> createState() => _AcquistoQuantitaState();
}

class _AcquistoQuantitaState extends State<AcquistoQuantita> {
  Orders nuovoOrdine = Orders(dataOrdine: DateTime.now());
  num valoreGrammi = 1;
  num valorePrezzoUnitario = 1;

  bool inCart = false;

  List<DealProduct> list = [];
  //Map<int, OrderProduct> map = {};


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list = super.widget.list;
    creaMappa();
  }

  void creaMappa(){
    for(DealProduct dealProduct in list){
      // Inizialmente valorizzo con il prezzo dettaglio stabilito , in acquisto prezzo sarà possibile modificare
      OrderProduct orderProduct = OrderProduct();
      dealProduct.productsOrder.add(orderProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool smthngInCart = nuovoOrdine.prodottiOrdine.isNotEmpty;

    return  Scaffold(
        appBar: AppBar(backgroundColor: CommonColors.background,
            title: const Text('Acquista prodotti', style: TextStyle(fontFamily: 'mosteraRegular')),
        ),
        persistentFooterButtons: [
          ElevatedButton(
            style: DealButtonStyles.elevatedButton,
            onPressed: () => showCarrello(context),
            child: Wrap(
              children: [
                const Icon(Icons.shopping_cart, color: CommonColors.black),
                AnimatedDigitWidget(
                  key:  const ValueKey("teal"),
                  suffix: '€',
                  textStyle: const TextStyle(fontFamily: 'bold'),
                  enableSeparator: true,
                  value: getTotaleCarrello(),
                  duration: const Duration(seconds: 2),
                  curve: Curves.bounceIn,
                ),
              ],
            )
          ),
          smthngInCart ?
          ElevatedButton(
              onPressed: () {
                list.forEach((element) {
                  element.productsOrder.last.prezzoAlDettaglio = element.prezzoDettaglio;
                });
                Navigator.pushNamed(context, RoutesDef.acquistoPrezzo, arguments: {'order' : nuovoOrdine});
              },
              style: DealButtonStyles.elevatedButton,
              child: Text('Continua', style: DealStyles.bold)
          ) :
          ElevatedButton(
              onPressed: () {
              },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey)),
              child: Text('Continua', style: DealStyles.bold)
          )

        ],
        body: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          left: 20,
          right: 20
        ),
        child: SingleChildScrollView(
          child: ClipRRect(
            borderRadius: DealStyles.dealRadius,
            child: _buildListaProdotti(list),
          ),
        )
      )
    );
  }


  /// Crea la lista
  Widget _buildListaProdotti(List<DealProduct> _data) {
    return ExpansionPanelList.radio(
      children: _data.map<ExpansionPanelRadio>((DealProduct dealProduct) {
        inCart = nuovoOrdine.prodottiOrdine.contains(dealProduct.productsOrder.last);
        Color tileColor = inCart ? CommonColors.secondary : CommonColors.primary;
        return ExpansionPanelRadio(
            value: dealProduct.id,
            backgroundColor: tileColor,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text("${dealProduct.product.target!.nomeProdotto} (${dealProduct.prezzoDettaglio} € al gr.)"),
                subtitle: Text(dealProduct.deal.target!.getDataCreazione())
              );
            },
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: creaFormProdotto(dealProduct)
            )
        );
      }).toList(),
    );
  }

  /// Crea il pannello del prodotto
  ExpansionPanel creaPannello(DealProduct dealProduct){
    return ExpansionPanelRadio(
        value: dealProduct.id,
        backgroundColor: CommonColors.primary,
        headerBuilder: (BuildContext context, bool isExpanded) {
          return ListTile(
            title: Text('${dealProduct.product.target!.nomeProdotto}  (${dealProduct.prezzoDettaglio} € al gr.)'),
            subtitle: Text(dealProduct.deal.target!.getDataCreazione()),
            shape: DealStyles.roundRectangleRadiusBorder,
          );
        },
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: creaFormProdotto(dealProduct)
        )
    );
  }

  /// Crea il form nel collapse
  Form creaFormProdotto(DealProduct dealProd){

    GlobalKey<FormState> _keyForm = GlobalKey<FormState>();


    TextEditingController controllerQuantita = TextEditingController();
    TextEditingController controllerPrezzo = TextEditingController();


    return Form(
      key: _keyForm,
      child: Wrap(
        runSpacing: 10,
        children: [
          const Text('Quantità richiesta (in gr) :'),
          NumberInputWithIncrementDecrement(
            controller: controllerQuantita,
            autovalidateMode: AutovalidateMode.disabled,
            fractionDigits: 1,
            incDecFactor: 0.5,
            initialValue: dealProd.productsOrder.last.quantitativoPrevisto,
            min: 1,
            max: dealProd.disponibilitaMercato,
            onDecrement: (value){
              setState(() {
                dealProd.productsOrder.last.quantitativoPrevisto = value.toDouble();
                dealProd.productsOrder.last.quantitativoEffetivo = value.toDouble();
              });
            },
            onChanged: (value){
              setState(() {
                dealProd.productsOrder.last.quantitativoPrevisto = value.toDouble();
                dealProd.productsOrder.last.quantitativoEffetivo = value.toDouble();
              });
            },
            onIncrement: (value){
              setState(() {
                dealProd.productsOrder.last.quantitativoPrevisto = value.toDouble();
                dealProd.productsOrder.last.quantitativoEffetivo = value.toDouble();
              });
            },
          ),
          const Text('Prezzo totale prodotto:'),
          NumberInputWithIncrementDecrement(
            controller: controllerPrezzo,
            min: 1,
            max: dealProd.disponibilitaMercato * dealProd.prezzoDettaglio,
            initialValue: dealProd.productsOrder.last.quantitativoPrevisto * dealProd.prezzoDettaglio,
            onIncrement: (value){
              setState(() {
                dealProd.productsOrder.last.quantitativoPrevisto = value / dealProd.prezzoDettaglio;
                dealProd.productsOrder.last.quantitativoEffetivo = value / dealProd.prezzoDettaglio;
              });
            },
            onChanged: (value){
              setState(() {
                dealProd.productsOrder.last.quantitativoPrevisto = value / dealProd.prezzoDettaglio;
                dealProd.productsOrder.last.quantitativoEffetivo = value / dealProd.prezzoDettaglio;
              });
            },
            onDecrement: (value){
              setState(() {
                dealProd.productsOrder.last.quantitativoPrevisto = value / dealProd.prezzoDettaglio;
                dealProd.productsOrder.last.quantitativoEffetivo = value / dealProd.prezzoDettaglio;
              });
            },
          ),
          inCart ?
          AnimatedButton(
            pressEvent: () => setState(() {
              nuovoOrdine.prodottiOrdine.remove(dealProd.productsOrder.last);
            }),
            text: 'Elimina',
            color: Colors.red,
          ) :
          AnimatedButton(
              pressEvent: () {
                setState(() {
                  dealProd.productsOrder.last.productDeals.target = dealProd;
                  if(!nuovoOrdine.prodottiOrdine.contains(dealProd.productsOrder.last)){

                    nuovoOrdine.prodottiOrdine.add(dealProd.productsOrder.last);
                  }
                });
              },
              text: 'Vendi',
              color: CommonColors.primary2
          )

        ],
      ),
    );
  }

  /// Mostra il carrello in basso
  void showCarrello(BuildContext context){

    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          builder: (_, controller) {
            return StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage('images/proud.png'),opacity: 0.1,fit: BoxFit.scaleDown),
                    color: CommonColors.secondary2,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0),
                    ),
                  ),
                  child: nuovoOrdine.prodottiOrdine.isEmpty ?  Center(child: Text('Il carrello è vuoto', style: DealStyles.bold)) :
                  ListView.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 10);
                    },
                    controller: controller,
                    itemCount: nuovoOrdine.prodottiOrdine.length,
                    itemBuilder: (_, index) {
                      OrderProduct orderProduct = nuovoOrdine.prodottiOrdine.elementAt(index);

                      return Container(
                        height: 60,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: DealStyles.dealRadius,
                          color: CommonColors.tertiary.withOpacity(0.7),
                        ),
                        child: Row(
                          children: [
                            Expanded(child: Text(orderProduct.productDeals.target!.product.target!.nomeProdotto,style: DealStyles.regular)),
                            Text('${orderProduct.getPrezzoTotale()} €', style: DealStyles.bold),
                            Text('(${orderProduct.quantitativoPrevisto}.gr)', style: DealStyles.italic),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  double getTotaleCarrello(){
    double totale = 0;
    nuovoOrdine.prodottiOrdine.forEach((pOrdine) {
      totale += pOrdine.quantitativoPrevisto * pOrdine.productDeals.target!.prezzoDettaglio;
    });
    return totale;
  }


}
