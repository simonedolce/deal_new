import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:omc/common_widget/card.dart';
import 'package:omc/util/colors.dart';
import 'package:omc/util/strings.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'common_widget/common_function.dart';
import 'data_grid_adapter/deal_adapter.dart';
import 'model/deal.dart';
import 'model/prodotto_deal.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QuickOverview extends StatefulWidget {
  const QuickOverview({Key? key}) : super(key: key);

  @override
  State<QuickOverview> createState() => _QuickOverviewState();


}
final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
class _QuickOverviewState extends State<QuickOverview> {

  List<Deal> _dealList = [];

  void getAllDeal() async {
    const platform = MethodChannel('com.example.omc/deal');
    List<dynamic> serializedList = await platform.invokeMethod('get_all_deal');
    List<Deal> dealList = [];

    for (String json in serializedList) {
      final deal = Deal.fromJson(jsonDecode(json));
      dealList.add(deal);
    }

    setState(() {
      _dealList = dealList;
    });
  }


  @override
  void initState() {
    super.initState();
    getAllDeal();
  }

  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey<ExpandableFabState>();
    Map<String, String> rows = {
      Strings.totaleDeals: _dealList.length.toString(),
      Strings.totaleSpeso: calcolaImportoTotaleSpeso().toString() + Strings.currency,
      Strings.totaleRientrato: calcolaImportoTotaleRientrato().toString() + Strings.currency,
    };

    SimpleTable sTable = SimpleTable(rows: rows);

    return Scaffold(
      appBar: CommonFunction().customAppBar(Strings.homePage),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: _key,
        duration: const Duration(milliseconds: 500),
        distance: 50.0,
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
                Icons.cancel,
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
          _dealList.isEmpty ? FloatingActionButton.small(
            onPressed: () {
              Fluttertoast.showToast(msg: Strings.errNoDeals);
            },
            backgroundColor: AppColors.secondary,
            child: const Icon(Icons.cancel),
          ) : FloatingActionButton.small(
            onPressed: () {
              Navigator.pushNamed(context, '/ordine', arguments: getProdottiDeals());
            },
            backgroundColor: AppColors.highlight,
            child: const Icon(Icons.handshake),
          ),
          FloatingActionButton.small(
            // shape: const CircleBorder(),
            heroTag: null,
            backgroundColor: AppColors.highlight,
            child: const Icon(Icons.search),
            onPressed: () {
            },
          ),
          FloatingActionButton.small(
            // shape: const CircleBorder(),
            heroTag: null,
            backgroundColor: AppColors.highlight,
            child: const Icon(Icons.share),
            onPressed: () {
              final state = _key.currentState;
              if (state != null) {
                debugPrint('isOpen:${state.isOpen}');
                state.toggle();
              }
            },
          ),
        ],
      ),
      body:  Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Quick Overview',style: TextStyle(fontFamily: 'bold', fontSize: 26)),
            const SizedBox(height: 13),
            Expanded(
              child: sTable
            )
            //sTable,

          ],
        ) ,
      ),
    );
  }
  double calcolaImportoTotaleSpeso(){
    return CommonFunction().calcolaTotaleSpeso(_dealList);
  }

  double calcolaImportoTotaleRientrato(){
    return CommonFunction().calcolaTotaleRientrato(_dealList);
  }

  List<ProdottoDeal> getProdottiDeals(){
    List<ProdottoDeal> allPD = [];
    _dealList.forEach((deal) {
      deal.prodottiDeals.forEach((pD) {
        allPD.add(pD);
      });
    });
    return allPD;
  }
}


