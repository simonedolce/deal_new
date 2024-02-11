import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:deal/main.dart';
import 'package:deal/util/colors.dart';
import 'package:deal/util/deal-button-styles.dart';
import 'package:deal/util/routes.dart';
import 'package:flutter/material.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

import '../../model/order-product.dart';
import '../../model/order.dart';
import '../../util/deal-styles.dart';

class AcquistoPrezzo extends StatefulWidget {
  const AcquistoPrezzo({super.key, required this.order});

  final Orders order;

  @override
  State<AcquistoPrezzo> createState() => _AcquistoPrezzoState();
}

class _AcquistoPrezzoState extends State<AcquistoPrezzo> {

  late Orders order ;

  @override
  void initState() {
    super.initState();
    order = widget.order;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        ElevatedButton(
          style: DealButtonStyles.elevatedButton,
          onPressed: () {

            Navigator.pushNamed(context, RoutesDef.acquistoCliente,
                arguments: {'order': order});
                },
          child: Text('Continua', style: DealStyles.bold)
        )
      ],
      appBar: AppBar(title: Text('Conferma Prezzo', style: DealStyles.mostera), backgroundColor: CommonColors.background),
      body: Padding(
          padding: const EdgeInsets.only(
            top: 10,
            left: 20,
            right: 20
          ),
        child: SingleChildScrollView(
          child: ClipRRect(
            borderRadius: DealStyles.dealRadius,
            child: _buildListaProdotti(order)
          ),
        )
      ),
    );
  }

  /// Crea la lista
  Widget _buildListaProdotti(Orders order) {
    return ExpansionPanelList.radio(
      children: order.prodottiOrdine.map<ExpansionPanelRadio>((OrderProduct orderProduct) {
        return ExpansionPanelRadio(
            value: orderProduct.productDeals.target!.id,
            backgroundColor: CommonColors.secondary,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                  title: Text("${orderProduct.productDeals.target!.product.target!.nomeProdotto} ${orderProduct.quantitativoPrevisto} gr."),
                  subtitle: Text('${orderProduct.productDeals.target!.prezzoDettaglio} € al gr. (prezzo originale)'),
              );
            },
            body: Padding(
                padding: const EdgeInsets.all(20),
                child: creaFormProdotto(orderProduct)
            )
        );
      }).toList(),
    );
  }

  /// Crea il form nel collapse
  Form creaFormProdotto(OrderProduct orderProduct){

    GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

    return Form(
      key: _keyForm,
      child: Wrap(
        runSpacing: 10,
        children: [
          Text('Prezzo unitario (in €):', style: DealStyles.italic),
          NumberInputWithIncrementDecrement(
            controller: TextEditingController(),
            autovalidateMode: AutovalidateMode.disabled,
            incDecFactor: 0.5,
            fractionDigits: 1,
            initialValue: orderProduct.prezzoAlDettaglio,
            min: 1,
            max: 99,
            onDecrement: (value){
              setState(() {
                orderProduct.prezzoAlDettaglio = value as double;
              });
            },
            onIncrement: (value){
              setState(() {
                orderProduct.prezzoAlDettaglio = value as double;
              });
            },
          ),
          Text('Prezzo totale prodotto (in €):', style: DealStyles.italic),
          NumberInputWithIncrementDecrement(
            controller: TextEditingController(),
            min: 1,
            max: 9999,
            autovalidateMode: AutovalidateMode.disabled,
            initialValue: orderProduct.getPrezzoTotale(),
            onIncrement: (value){
              setState(() {
                orderProduct.prezzoAlDettaglio = value / orderProduct.quantitativoPrevisto;
              });
            },
            onDecrement: (value){
              setState(() {
                orderProduct.prezzoAlDettaglio = value / orderProduct.quantitativoPrevisto;
              });
            },
          ),
          Text('Quantitativo effettivo (in gr.)', style: DealStyles.italic),
          NumberInputWithIncrementDecrement(
            controller: TextEditingController(),
            min: 1,
            max: 9999,
            autovalidateMode: AutovalidateMode.disabled,
            initialValue: orderProduct.quantitativoEffetivo,
            onIncrement: (value){
              setState(() {
                orderProduct.quantitativoEffetivo = value.toDouble();
              });
            },
            onDecrement: (value){
              setState(() {
                orderProduct.quantitativoEffetivo = value.toDouble();
              });
            },
          ),
        ],
      ),
    );
  }
}
