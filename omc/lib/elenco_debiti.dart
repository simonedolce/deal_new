import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omc/common_widget/common_function.dart';
import 'package:omc/model/customer.dart';
import 'package:omc/model/ordine.dart';
import 'package:omc/util/colors.dart';
import 'package:omc/util/strings.dart';

import 'model/sanamento_debito.dart';

class ElencoDebiti extends StatefulWidget {
  const ElencoDebiti({Key? key}) : super(key: key);

  @override
  State<ElencoDebiti> createState() => ElencoDebitiState();
}



class ElencoDebitiState extends State<ElencoDebiti> {

  List<Customer> customersDebiti = [];
  Future<void> getClientiConDebiti() async {
    const platform = MethodChannel('com.example.omc/debt');
    List<dynamic> serializedList = await platform.invokeMethod('get_all_debts');
    List<Customer> clientiList = [];

    for (String json in serializedList) {
      final customer = Customer.fromJson(jsonDecode(json));
      clientiList.add(customer);
    }

    setState(() {
      customersDebiti = clientiList;
    });
  }

  @override
  void initState() {
    super.initState();
    getClientiConDebiti();
  }

  @override
  Widget build(BuildContext context) {
    BuildContext mainContext = context;
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
      appBar:  CommonFunction().customAppBar(Strings.elencoDebiti),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 26),

          child: customersDebiti.isNotEmpty ? Column(
            children: [
              const Text(Strings.elencoDebiti, style: TextStyle(fontFamily: 'regular',fontSize: 24)),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 13, vertical: 13)),
              Expanded(
                child: ListView.builder(
                  itemCount: customersDebiti.length,
                  itemBuilder: (context, index) {
                    Customer customer = customersDebiti[index];
                    String ordineOrdini = customer.ordini!.length > 1 ? Strings.ordini : Strings.ordine;
                    return Card(
                      elevation: 5,
                      child: ListTile(
                        onTap: (){
                          Navigator.pushNamed(mainContext, '/dettaglioDebiti', arguments: customer);
                        },
                        onLongPress: () {
                        },
                        leading: const CircleAvatar(
                            backgroundColor: AppColors.highlight,
                            child: Icon(Icons.payments)
                        ),
                        title: Text(
                          customer.nome,
                          style: const TextStyle(fontSize: 20, fontFamily: 'medium'),
                        ),
                        subtitle: Text(
                          "${CommonFunction().getTotaleDebito(customer)} ${Strings.currency} / ${customer.ordini?.length} $ordineOrdini" ,
                          style: const TextStyle(fontSize: 12.5, fontFamily: 'medium'),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ) : const Center(child: Text(Strings.noDebts ,style: TextStyle(fontFamily: 'mediumItalic',fontSize: 12)),
        ),
      ),
    ));
  }



}
