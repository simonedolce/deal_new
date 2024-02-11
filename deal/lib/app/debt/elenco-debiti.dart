import 'package:deal/services/customer-service.dart';
import 'package:deal/services/debt-service.dart';
import 'package:deal/util/text-styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../model/customer.dart';
import '../../model/debt.dart';
import '../../util/colors.dart';
import '../../util/deal-styles.dart';
import '../../util/routes.dart';

class ElencoDebiti extends StatefulWidget {
  const ElencoDebiti({super.key});

  @override
  State<ElencoDebiti> createState() => _ElencoDebitiState();
}

class _ElencoDebitiState extends State<ElencoDebiti> {
  List<Customer> customersIndebitati = [];
  DebtService debtService = DebtService();
  CustomerService customerService = CustomerService();

  @override
  void initState() {
    super.initState();
    customersIndebitati = customerService.getListaCustomerIndebitati();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: CommonColors.background,title: Text('Elenco Debiti', style: DealTextStyles(fontName: 'mosteraRegular').textStyleDark)),
      body: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width/10),
          child: SingleChildScrollView(
              child: Wrap(
                runSpacing: 20,
                children: <Widget>[
                  customersIndebitati.isNotEmpty ? ListView.separated(
                      shrinkWrap: true,
                      reverse: true,
                      itemBuilder: (context, index) {
                        Customer customerIndebitato = customersIndebitati.elementAt(index);
                        return ListTile(
                          title: Text(customerIndebitato.name),
                          shape: DealStyles.roundRectangleRadiusBorder,
                          subtitle: Text('${customerIndebitato.totaleDebitoDovuto()} €'),
                          tileColor: CommonColors.dirtyWhite,
                          leading: TextButton(
                              child: const Text('Apri'),
                              onPressed: () {
                                Navigator.pushNamed(context, RoutesDef.sanaDebito, arguments: {'customer': customerIndebitato});
                              }
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10);
                      },
                      itemCount: customersIndebitati.length
                  ) : const Center(child: Text('Nessun ordine da visualizzare'))
                ],
              )
          )
      ),
    );
  }


  Widget creaFormFiltri() {
    return ExpansionTile(
      title: Text('Filtri'),
      leading: const FaIcon(
        FontAwesomeIcons.filter,
      ),
      collapsedBackgroundColor: CommonColors.secondary,
      collapsedShape: DealStyles.roundRectangleRadiusBorder,
      shape: DealStyles.roundRectangleRadiusBorder,
      backgroundColor: CommonColors.primary2,
      childrenPadding: const EdgeInsets.all(20),
      children: [


      ],

    );
  }
}
