import 'package:flutter/material.dart';
import 'package:omc/common_widget/common_function.dart';
import 'package:omc/model/prodotto_deal.dart';
import 'package:omc/util/colors.dart';
import 'package:omc/util/strings.dart';

class EditProdottoDeal extends StatefulWidget {
  const EditProdottoDeal({Key? key}) : super(key: key);

  @override
  State<EditProdottoDeal> createState() => _EditProdottoDealState();
}

class _EditProdottoDealState extends State<EditProdottoDeal> {



  @override
  Widget build(BuildContext context) {

    final ProdottoDeal pDeal = ModalRoute.of(context)!.settings.arguments as ProdottoDeal;

    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.editProdottoDeal),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.secondary,
          onPressed: (){

          }, // Apri la modal del carrello
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit, size: 20),
            ],
          ),
        ),
        body: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: CommonFunction().returnText(pDeal.prodotto.nomeProdotto, 30),
              )
            ),
             Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    CommonFunction().returnText('Quantitativo disponibile: ${pDeal.disponibilitaMercato} ${Strings.uMisura}', 15),
                  ],
                ),
            )

          ],
        ),
      ),
    );
  }
}



