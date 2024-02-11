import 'package:deal/services/deal-service.dart';
import 'package:deal/util/colors.dart';
import 'package:deal/util/deal-styles.dart';
import 'package:deal/util/routes.dart';
import 'package:deal/util/text-styles.dart';
import 'package:flutter/material.dart';
import '../../model/deal.dart';

class ElencoDeal extends StatefulWidget {
  const ElencoDeal({super.key});

  @override
  State<ElencoDeal> createState() => _ElencoDealState();
}

class _ElencoDealState extends State<ElencoDeal> {
  late List<Deal> dealList;
  DealService dealService = DealService();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dealList = dealService.getAll();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Elenco Deal' , style: DealTextStyles(fontName: 'mosteraRegular').textStyleDark),backgroundColor: CommonColors.background),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.separated(
            itemCount: dealList.length,
            itemBuilder: (context, index) {
              Deal deal = dealList.elementAt(index);
              return ListTile(
                leading: Text(deal.id.toString()),
                title: Text('${deal.prodottiDeals.length} Strain/Tipi '),
                subtitle: Text('${deal.getTotaleImportoRientrato()}/${deal.getTotaleImportoInvestito()} €'),
                shape: DealStyles.roundRectangleRadiusBorder,
                tileColor: CommonColors.dirtyWhite,
                onTap: () {
                  Navigator.pushNamed(context, RoutesDef.dettaglioDeal,arguments: {'deal' : deal});
                },
              );
            }, separatorBuilder: (BuildContext context, int index) { return SizedBox(height: 10); },
        ),
      ),
    );
  }
}
