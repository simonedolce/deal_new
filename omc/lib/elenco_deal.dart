import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:omc/util/colors.dart';
import 'common_widget/animated_dialog.dart';
import 'common_widget/common_function.dart';
import 'common_widget/fa_progress_bar.dart';
import 'model/deal.dart';
import 'util/strings.dart';

class ElencoDeal extends StatefulWidget {
  const ElencoDeal({Key? key}) : super(key: key);

  @override
  State<ElencoDeal> createState() => _ElencoDealState();
}

class _ElencoDealState extends State<ElencoDeal>
    with SingleTickerProviderStateMixin {
  List<Deal> _dealList = [];
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    );

    getAllDeal();
  }

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
  Widget build(BuildContext mainContext) {
    return MaterialApp(
      darkTheme: CommonFunction().darkTheme(),
      home: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(mainContext, '/aggiungiDeal');
          },
          backgroundColor: AppColors.highlight,
          child: const Icon(Icons.add_box_rounded),
        ),
        appBar: CommonFunction().customAppBar(Strings.elencoDeals),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 26),
          child: _dealList.isNotEmpty ? Column(
            children: [
              const Text(Strings.elencoDeals, style: TextStyle(fontFamily: 'regular',fontSize: 24)),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 13, vertical: 13)),
              Expanded(
                child: ListView.builder(
                  itemCount: _dealList.length,
                  itemBuilder: (context, index) {
                    Deal deal = _dealList[index];
                    return Card(
                      elevation: 5,
                      child: ListTile(
                          onTap: (){
                            Navigator.pushNamed(mainContext, '/dealPage',arguments: deal);
                          },
                          onLongPress: () {
                            _showDialog(context);
                          },
                          leading: CircleAvatar(
                              backgroundColor: AppColors.highlight,
                              child: Text(deal.id.toString(), style: const TextStyle(color: AppColors.background,fontFamily: 'bold', fontWeight: FontWeight.w400),)
                          ),
                          title: Text(
                            '${deal.disponibilitaTotaleMercato} ${Strings.uMisura}',
                            style: const TextStyle(fontSize: 20,color: AppColors.headline,fontFamily: 'medium'),
                          ),
                          subtitle: Text(
                            deal.formatDate(),
                            style: const TextStyle(fontSize: 12.5,fontFamily: 'regular'),
                          ),

                      ),
                    );
                  },
                ),
              ),
            ],
          ) : const Center(
              child: Text(Strings.noDeals, style: TextStyle(fontFamily: 'mediumItalic',fontSize: 12))
          )
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AnimatedDialog(title: 'title', widgets: [

        ]);
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


Widget? getRowDealParameter(String text , String parameter , String unitaMisura ){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 26,vertical: 10),
    child:
    Row(children: [
      Text(text),
      Text("$parameter $unitaMisura", style: const TextStyle(fontSize: 15),),
    ]),
  );
}



void main() {
  runApp(MaterialApp(home: ElencoDeal()));
}