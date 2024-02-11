import 'package:deal/app/customer/crea-customer.dart';
import 'package:deal/app/deal/dettaglio-deal.dart';
import 'package:deal/app/deal/elenco-deal.dart';
import 'package:deal/app/debt/elenco-debiti.dart';
import 'package:deal/app/debt/inserisci-sanamento.dart';
import 'package:deal/app/debt/sana-debito.dart';
import 'package:deal/app/ordine/acquisto-cliente.dart';
import 'package:deal/app/ordine/acquisto-dettaglio.dart';
import 'package:deal/app/ordine/acquisto-prezzo.dart';
import 'package:deal/app/deal/conferma-deal.dart';
import 'package:deal/app/deal/crea-deal-product.dart';
import 'package:deal/app/deal/crea-deal.dart';
import 'package:deal/app/ordine/dettaglio-ordine.dart';
import 'package:deal/app/ordine/elenco-ordini.dart';
import 'package:deal/app/prodotto/crea-prodotto.dart';
import 'package:deal/app/dashboard.dart';
import 'package:deal/app/introduction.dart';
import 'package:deal/model/deal-product.dart';
import 'package:deal/util/colors.dart';
import 'package:deal/util/routes.dart';
import 'package:flutter/material.dart';

import '../model/customer.dart';
import '../model/deal.dart';
import '../model/debt.dart';
import '../model/order.dart';

class AppStarter extends StatelessWidget {
  final bool isInitiated;
  const AppStarter({super.key, required this.isInitiated});

  @override
  Widget build(BuildContext context) {

    String initialRoute = isInitiated ? RoutesDef.dashBoard : RoutesDef.introduction;

    return MaterialApp(
      title: 'Deal',
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: CommonColors.background).copyWith(background: CommonColors.background),
      ),
      initialRoute: initialRoute,
      routes: {
        RoutesDef.introduction: (context) => const Introduction(),
        RoutesDef.dashBoard: (context) => const DashBoard(),
        RoutesDef.creaCustomer: (context) => const CreaCustomer(),
        RoutesDef.creaDeal: (context) => const CreaDeal(),
        RoutesDef.creaProdotto: (context) => const CreaProdotto(),
        RoutesDef.elencoOrdini: (context) => const ElencoOrdini(),
        RoutesDef.elencoDebiti: (context) => const ElencoDebiti(),
        RoutesDef.elencoDeal: (context) => const ElencoDeal(),
        RoutesDef.creaProdottoDeal: (context) {
          /// FASE 1 DEL DEAL - SI DETERMINA QUANTITA' E COSTO DEI PRODOTTI DA RIVENDERE
          final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          final Deal param = args['deal'] as Deal;
          return CreaDealProduct(deal: param);
        },
        RoutesDef.confermaDeal: (context) {
          /// FASE 2 DEL DEAL - SI DETERMINA QUANTITA' E COSTO DEI PRODOTTI DA RIVENDERE
          final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          final Deal param = args['deal'] as Deal;
          return ConfermaDeal(deal: param);
        },
        RoutesDef.acquistaDettaglio: (context) {
          /// FASE 1 DELLA CREAZIONE ORDINE - SI DETERMINA LA QUANTITA E IL PREZZO IN BASE ALLA QUANTITA
          final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          final List<DealProduct> list = args['prodList'] as List<DealProduct>;
          return AcquistoQuantita(list: list);
        },
        RoutesDef.acquistoPrezzo: (context) {
          /// FASE 2 DELLA CREAZIONE ORDINE - SI DETERMINA IL PREZZO TOTALE IN BASE AL PREZZO UNITARIO
          final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          final Orders order = args['order'] as Orders;
          return AcquistoPrezzo(order: order);
        },
        RoutesDef.acquistoCliente: (context) {
          /// FASE 3 DELLA CREAZIONE ORDINE - SI DETERMINA IL CLIENTE E IL RIENTRATO DELL'ORDINE
          final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          final Orders order = args['order'] as Orders;
          return AcquistoCliente(order: order);
        },
        RoutesDef.dettaglioOrdine: (context) {
          /// IL DETTAGLIO DELL'ORDINE CON INFORMAZIONI SUL PAGAMENTO E PRODOTTI ACQUISTATI
          final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          final Orders order = args['order'] as Orders;
          return DettaglioOrdine(order: order);
        },
        RoutesDef.dettaglioDeal: (context) {
          /// IL DETTAGLIO DEL DEAL CON INFORMAZIONI SPECIFICHE SUL DEAL
          final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          final Deal deal = args['deal'] as Deal;
          return DettaglioDeal(deal: deal);
        },
        RoutesDef.inserisciSanamento: (context) {
          final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          final Debt debt = args['debt'] as Debt;
          return InserisciSanamento(debt: debt);
        },
        RoutesDef.sanaDebito: (context) {
          final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          final Customer customer = args['customer'] as Customer;
          return SanaDebito(customer: customer);
        }
      },
    );
  }
}