import 'package:deal/model/order-product.dart';
import 'package:deal/services/customer-service.dart';
import 'package:deal/util/colors.dart';
import 'package:deal/util/deal-styles.dart';
import 'package:deal/util/text-styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../model/order.dart';

class DettaglioOrdine extends StatefulWidget {
  final Orders order;
  const DettaglioOrdine({super.key, required this.order});

  @override
  State<DettaglioOrdine> createState() => _DettaglioOrdineState();
}

class _DettaglioOrdineState extends State<DettaglioOrdine> {
  late Orders order;
  bool debitoInCorso = false;
  late String prodottiString = '';

  CustomerService customerService = CustomerService();
  int progressivoOrdine = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    order = widget.order;
    debitoInCorso = order.hasDebt();
    order.prodottiOrdine.forEach((element) {
      prodottiString += '- ${element.productDeals.target!.product.target!.nomeProdotto}\n';
    });
    progressivoOrdine = customerService.trovaProgressivoOrdine(order);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dettaglio Ordine' , style: DealStyles.mostera),backgroundColor: CommonColors.background),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width / 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              Text('Dettaglio ordine di ${order.customer.target!.name}', style: DealTextStyles(fontSize: 25).textStyleDark),
              Text('Data: ${order.getDataCreazione()}', style: const TextStyle(fontSize: 16, fontFamily: 'regular')),
              Text(prodottiString,style: DealTextStyles(fontSize: 10).textStyleDark),
              const SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: CommonColors.dark
                  ),
                  color: CommonColors.secondary2,
                  borderRadius: const BorderRadius.all(Radius.circular(20))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    ListTile(
                      title: debitoInCorso ? Text('Debito in corso',style: DealTextStyles(fontSize: 16).textStyleDark)
                          : Text('Ordine Pagato',style: DealTextStyles(fontSize: 16).textStyleDark),

                      subtitle: debitoInCorso ?  Text('Ti deve ancora : ${order.debito.target!.importoDebito} €',style: DealTextStyles(fontSize: 10,fontName: 'bold').textStyleDark)
                          : Text('${order.totale} €',style: DealTextStyles(fontSize: 10,fontName: 'bold').textStyleDark),
                      leading: debitoInCorso ? const FaIcon(FontAwesomeIcons.handHoldingDollar) : const FaIcon(FontAwesomeIcons.dollarSign),
                    ),
                    ListTile(
                      title: Text('Ordine numero : ${progressivoOrdine}',style: DealTextStyles(fontSize: 16).textStyleDark),

                      subtitle: Text("Questo e l' ordine numero ${progressivoOrdine} di ${order.customer.target!.name}", style: DealTextStyles(fontSize: 10,fontName: 'bold').textStyleDark,),
                      leading: FaIcon(FontAwesomeIcons.coins),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


}
