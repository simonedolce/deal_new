import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omc/aggiungi_deal.dart';
import 'package:omc/crea_prodotto.dart';
import 'package:omc/dettaglio_deal.dart';
import 'package:omc/dettaglio_debiti.dart';
import 'package:omc/edit_prodotto_deal.dart';
import 'package:omc/elenco_debiti.dart';
import 'package:omc/home_page.dart';
import 'package:omc/ordine_from_deal.dart';
import 'package:omc/riepilogo_ordine.dart';
import 'package:omc/util/colors.dart';
import 'schermata_iniziale.dart';
import 'elenco_deal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const platform = MethodChannel('com.example.omc/init');
  String route = '/schermataIniziale';

  try {
    final bool result = await platform.invokeMethod('is_active_user');
    if(result){
      route = '/homePage';
    }
  } on PlatformException catch (e) {
    // Gestisci eventuali errori
  }

  runApp((Main(route)));
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: AppColors.highlight,
    statusBarColor:  AppColors.highlight,

  ));
}

class Main extends StatelessWidget {
  final String initialRoute;

  Main(this.initialRoute);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData.dark(),
      initialRoute: initialRoute, // Schermata iniziale
      routes: {
        '/schermataIniziale': (context) => SchermataIniziale(),
        '/dealPage': (context) =>  DettaglioDeal(),
        '/homePage': (context) => HomePage(),
        '/elencoDeal': (context) =>  ElencoDeal(),
        '/aggiungiDeal': (context) =>  AggiungiDeal(),
        '/creaProdotto': (context) =>  CreaProdotto(),
        '/ordine': (context) =>  OrdineFromDeal(),
        '/editPDeal': (context) =>  EditProdottoDeal(),
        '/riepilogoOrdine': (context) => RiepilogoOrdine(),
        '/elencoDebiti': (context) => ElencoDebiti(),
        '/dettaglioDebiti': (context) => DettaglioDebiti()
      },
    );
  }
}


