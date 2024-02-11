import 'package:animated_digit/animated_digit.dart';
import 'package:deal/model/deal.dart';
import 'package:deal/model/debt.dart';
import 'package:deal/services/customer-service.dart';
import 'package:deal/services/deal-service.dart';
import 'package:deal/services/debt-service.dart';
import 'package:deal/services/order-service.dart';
import 'package:deal/util/colors.dart';
import 'package:deal/util/deal-button-styles.dart';
import 'package:deal/util/deal-styles.dart';
import 'package:deal/util/text-styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../model/deal-product.dart';
import '../model/order.dart';
import '../services/deal-product-service.dart';
import '../util/routes.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> with SingleTickerProviderStateMixin {
  late List<Deal> _dealsList = [];
  late List<DealProduct> _allProd = [];
  late List<Orders> _allOrdini = [];
  late List<Debt> _allDebts = [];

  late List<Orders> customersIndebitati = [];

  late Deal _ultimoDeal = Deal(dataDeal: DateTime.now());
  late List<DealProduct> dealProductList;
  late Map<String , dynamic> informazioniOrdini = {};
  late Map<String , dynamic> informazioniDebiti = {};

  DealService dealService = DealService();
  DealProductService dealProductService = DealProductService();
  OrderService orderService = OrderService();
  DebtService debtService = DebtService();
  CustomerService customerService = CustomerService();
  String mainText = '';
  List<Widget> tiles = [];


  @override
  void initState() {
    super.initState();
    customersIndebitati = orderService.getOrdiniConDebiti();

    dealProductList = dealProductService.getDisponibile();

    _dealsList = dealService.getAll();
    _allOrdini = orderService.getAll();
    _allProd = dealProductService.getAll();
    _allDebts = debtService.getAllAttivi();

    if(_allOrdini.isNotEmpty){
      informazioniOrdini = orderService.informazioniOrdini(_allOrdini);
    }

    if(_allDebts.isNotEmpty){
      informazioniDebiti = debtService.informazioniDebiti(_allDebts);
    }

    if(_dealsList.isNotEmpty){
      _ultimoDeal = _dealsList.last;
    }

    mainText = _dealsList.isNotEmpty ?
    'Al momento stai gestendo ${_dealsList.length} deal' :
    'Al momento non hai deal da gestire , usa la funzione Crea Deal per crearne uno';

  }

  Future<List<DealProduct>> getAllProdotti()  {
    return dealProductService.getAllAsync();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CommonColors.background,
        title: const Text('Dashboard', style: TextStyle(fontFamily: 'mosteraRegular')),
      ),
      drawer: Drawer(
          child: Drawer(
            backgroundColor: CommonColors.primary3,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                 DrawerHeader(
                  decoration: const BoxDecoration(
                    color: CommonColors.background,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'images/deal.png',
                      ),
                      Expanded(child: Text('Plugs Helper' , style: DealTextStyles(fontName: 'regular',fontSize: 20).textStyleDark,overflow: TextOverflow.ellipsis))
                    ],
                  )
                ),
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.list),
                  title: Text('Lista Deals', style: DealTextStyles(fontSize: 16).textStyleDark),
                  onTap: () {
                    Navigator.pushNamed(context, RoutesDef.elencoDeal);
                  },
                ),
              ],
            ),
          )
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 10,
          left: 20,
          right: 20
        ),
        child: SafeArea(
            child: Wrap(
              runSpacing: 10,
              children: [
                ListTile(
                  title: const Text('Benvenuto'),
                  subtitle: Text(mainText),
                  shape: DealStyles.roundRectangleRadiusBorder,
                  tileColor: CommonColors.primary,
                  leading: Image.asset(
                    'images/char.png',
                    fit: BoxFit.cover,
                  ),
                ),
                if(_dealsList.isNotEmpty) getExpansionTitleUltimoDeal(),
                if(_allOrdini.isNotEmpty) getExpansionTitleOrdini(),
                if(_allDebts.isNotEmpty) getExpansionTitleDebiti(),
                if(dealProductList.isNotEmpty)  Container(alignment: Alignment.center,child: const Text('Prodotti e disponibilità: ', style: TextStyle(fontFamily: 'regular', fontSize: 16))) ,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 2.0,
                    children: dealProductList.map((product) {

                      return product.disponibilitaMercato > 0 ?
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration:  BoxDecoration(
                          border: Border.all(color: CommonColors.black,strokeAlign: 0.5),
                          color: CommonColors.primary3,
                          borderRadius: const BorderRadius.all(Radius.circular(20)),

                        ),

                        alignment: Alignment.center,
                        width: 150,

                        child: Column(
                          children: [
                            Text('${product.disponibilitaMercato} gr.',style: DealTextStyles(fontSize: 10).textStyleDark),
                            Container(
                              padding: const EdgeInsets.all(10),
                              width: 80,
                              height: 80,
                              child: Image.asset('images/char.png'),
                            ),

                            const SizedBox(height: 8.0),

                            Text(product.product.target!.nomeProdotto, style: DealTextStyles(fontSize: 16).textStyleDark),

                            OutlinedButton(
                              child: Text('Acquista', style: DealTextStyles(fontSize: 10).textStyleDark),
                              onPressed: () {
                                List<DealProduct> list = [];
                                list.add(product);
                                Navigator.pushNamed(context, RoutesDef.acquistaDettaglio, arguments: {'prodList' : list});
                              },
                            )

                          ],

                        ),

                      ) : const SizedBox();

                    }).toList(),

                  ),
                ),

              ],
            )
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,

      floatingActionButton: ExpandableFab(
        duration: const Duration(milliseconds: 500),
        distance: 80.0,
        type: ExpandableFabType.up,
        pos: ExpandableFabPos.right,
        childrenOffset: const Offset(0, 20),
        fanAngle: 40,
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          heroTag: 'hero',
          child: const Icon(Icons.list),
          fabSize: ExpandableFabSize.regular,
          shape: const CircleBorder(),
          angle: 3.14 * 8,
        ),
        closeButtonBuilder: FloatingActionButtonBuilder(
          size: 56,
          builder: (BuildContext context, void Function()? onPressed,
              Animation<double> progress) {
            return IconButton(
              onPressed: onPressed,
              icon: const Icon(
                Icons.cancel,
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
            heroTag: 'hero1',
            label: const Wrap(spacing: 5, children: [FaIcon(FontAwesomeIcons.arrowRight), Text("Crea deal", style: TextStyle(fontFamily: 'bold'))]),
            onPressed: () {
              Navigator.pushNamed(context,RoutesDef.creaDeal);
            },
          ),
          FloatingActionButton.extended(
            heroTag: 'hero2',
            label: const Wrap(spacing: 5, children: [FaIcon(FontAwesomeIcons.arrowLeft), Text("Crea ordine", style: TextStyle(fontFamily: 'bold'))]),
            onPressed: () {
              Navigator.pushNamed(context, RoutesDef.acquistaDettaglio, arguments: {'prodList' : _allProd});
            },
          ),
        ],
      ),
    );
  }

  Widget getExpansionTitleDebiti(){
    return ExpansionTile(
      title: const Text('Debiti', style: TextStyle(fontFamily: 'bold')),
      leading: const FaIcon(
        FontAwesomeIcons.handHoldingDollar,
      ),
      collapsedBackgroundColor: CommonColors.primary,
      collapsedShape: DealStyles.roundRectangleRadiusBorder,
      shape: DealStyles.roundRectangleRadiusBorder,
      backgroundColor: CommonColors.primary2,
      childrenPadding: const EdgeInsets.all(20),
      children: [
        SizedBox(
            width: double.infinity,
            child: TextButton(
              style: DealButtonStyles.outlinedButton,
              onPressed: () {
                Navigator.pushNamed(context, RoutesDef.elencoDebiti);
              },
              child: Text('${_allDebts.length} debiti presenti al momento', style: DealStyles.regular),
            )
        ),
        const Divider(color: CommonColors.black),
        SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height / 4,
              child: Wrap(
                runSpacing: 10,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('Totale credito: ', style: DealTextStyles(fontName: DealTextStyles.regular, fontSize: 12).textStyleDark)),
                      Text(informazioniDebiti['totale_debito'] , style: DealTextStyles(fontName: DealTextStyles.bold,fontSize: 12).textStyleDark)
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Text('Cliente più indebitato: ', style: DealTextStyles(fontName: DealTextStyles.regular,fontSize: 12).textStyleDark)),
                      Text(informazioniDebiti['cliente_indebitato'] , style: DealTextStyles(fontName: DealTextStyles.bold,fontSize: 12).textStyleDark)
                    ],
                  ),
                ],
              )
            )
        ),
      ],
    );
  }

  Widget getExpansionTitleOrdini(){
    return ExpansionTile(
      title: const Text('Ordini', style: TextStyle(fontFamily: 'bold')),
      leading: const FaIcon(
        FontAwesomeIcons.list,
      ),
      collapsedBackgroundColor: CommonColors.primary,
      collapsedShape: DealStyles.roundRectangleRadiusBorder,
      shape: DealStyles.roundRectangleRadiusBorder,
      backgroundColor: CommonColors.primary2,
      childrenPadding: const EdgeInsets.all(20),
      children: [
        SizedBox(
          width: double.infinity,
          child: TextButton(
            style: DealButtonStyles.outlinedButton,
            onPressed: () {
              Navigator.pushNamed(context, RoutesDef.elencoOrdini);
            },
          child: Text('${_allOrdini.length} ordini presenti al momento', style: DealStyles.regular),
        )
        ),
        const Divider(color: CommonColors.black),
        SafeArea(
            child: Container(
              padding: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height / 4,
              child: Wrap(
                runSpacing: 10,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('Totale venduto: ', style: DealTextStyles(fontName: DealTextStyles.regular, fontSize: 12).textStyleDark)),
                      Text(informazioniOrdini['totale_venduto'] , style: DealTextStyles(fontName: DealTextStyles.bold,fontSize: 12).textStyleDark)
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Text('Totale rientrato: ', style: DealTextStyles(fontName: DealTextStyles.regular, fontSize: 12).textStyleDark)),
                      Text(informazioniOrdini['totale_rientrato'] , style: DealTextStyles(fontName: DealTextStyles.bold,fontSize: 12).textStyleDark)
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Text('Cliente affezionato: ', style: DealTextStyles(fontName: DealTextStyles.regular,fontSize: 12).textStyleDark)),
                      Text(informazioniOrdini['cliente_affezionato'] , style: DealTextStyles(fontName: DealTextStyles.bold,fontSize: 12).textStyleDark)
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Text('Miglior prodotto: ', style: DealTextStyles(fontName: DealTextStyles.regular,fontSize: 12).textStyleDark)),
                      Text(informazioniOrdini['miglior_prodotto'] , style: DealTextStyles(fontName: DealTextStyles.bold,fontSize: 12).textStyleDark)
                    ],
                  ),

                ],
              )
            )
        ),
      ],
    );
  }


  Widget getExpansionTitleUltimoDeal(){
    return ExpansionTile(
      title: const Text('Ultimo deal', style: TextStyle(fontFamily: 'bold')),
      leading: const FaIcon(
        FontAwesomeIcons.moneyCheckDollar,
      ),
      collapsedBackgroundColor: CommonColors.primary,
      collapsedShape: DealStyles.roundRectangleRadiusBorder,
      shape: DealStyles.roundRectangleRadiusBorder,
      backgroundColor: CommonColors.primary2,
      childrenPadding: const EdgeInsets.all(20),
      children: [
        Container(
          height: 100,
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(child: Text('Importo investito: ')),
                  AnimatedDigitWidget(
                    key:  const ValueKey("teal"),
                    suffix: '€',
                    textStyle: const TextStyle(fontFamily: 'bold'),
                    enableSeparator: true,
                    value: _ultimoDeal.getTotaleImportoInvestito(),
                    duration: const Duration(seconds: 2),
                    curve: Curves.bounceIn,
                  ),
                ],
              ),
              const Divider(color: CommonColors.background),
              Row(
                children: [
                  const Expanded(child: Text('Importo rientrato: ')),
                  AnimatedDigitWidget(
                    key:  const ValueKey("teal2"),
                    suffix: '€',
                    textStyle: const TextStyle(fontFamily: 'bold'),
                    value: _ultimoDeal.getTotaleImportoRientrato(),
                    duration: const Duration(seconds: 2),
                    curve: Curves.bounceIn,
                  ),
                ],
              ),
              const Divider(color: CommonColors.background),


            ],
          ),
        )
      ],
    );
  }




}