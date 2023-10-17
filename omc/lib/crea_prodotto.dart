import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omc/common_widget/input_field.dart';
import 'package:omc/model/prodotto.dart';
import 'package:omc/model/tipo_prodotto.dart';
import 'common_widget/button_style.dart';
import 'util/strings.dart';

class CreaProdotto extends StatefulWidget {
  const CreaProdotto({Key? key}) : super(key: key);

  @override
  State<CreaProdotto> createState() => _CreaProdottoState();
}

class _CreaProdottoState extends State<CreaProdotto> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final TextEditingController _nomeInputFieldController = TextEditingController();
  late final InputField _nomeInputField;

  int? _valTipoProdottoChips = 1;

  List<TipoProdotto> tipoProdottoList = [];

  _CreaProdottoState(){
    _nomeInputField = InputField(label: Strings.nomeProdotto,controller: _nomeInputFieldController, obscure: false,);
  }

  @override
  void initState() {
    super.initState();
    getTipiProdotti();

  }

  Future<void> insertProdotto(Prodotto prodotto) async {
    const platform = MethodChannel('com.example.omc/crea_prodotto');

    await platform.invokeMethod('insert_prodotto', {
      'nomeProdotto': prodotto.nomeProdotto,
      'idTipoProdotto': prodotto.tipoProdotto.id.toString(),
    });


  }

  void getTipiProdotti() async {
    const platform = MethodChannel('com.example.omc/crea_prodotto');
    List<dynamic> serializedList = await platform.invokeMethod('get_all_tipo_prodotto');
    List<TipoProdotto> updatedList = [];

    for (String json in serializedList) {
      final tipoProdotto = TipoProdotto.fromJson(jsonDecode(json));
      updatedList.add(tipoProdotto);
    }

    setState(() {
      tipoProdottoList = updatedList;
    });

  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          appBar: AppBar(
          title: const Text(Strings.creaProdotto),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 26),
            child: Column(
              children: [
                Form(
                  key: _key,
                  child: Column(
                    children: [
                      _nomeInputField,
                      Wrap(
                        spacing: 5.0,
                        children: tipoProdottoList.map((tipoProdotto) {
                          return ChoiceChip(
                            label: Text(tipoProdotto.descrizione),
                            selected: _valTipoProdottoChips == tipoProdotto.id,
                            onSelected: (bool selected) {
                              setState(() {
                                _valTipoProdottoChips = selected ? tipoProdotto.id : null;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  onPressed: (){
                    if(_key.currentState!.validate() && _valTipoProdottoChips != null){
                      TipoProdotto tipoProdotto = TipoProdotto(_valTipoProdottoChips!, '');
                      Prodotto prodotto = Prodotto(0, _nomeInputFieldController.text, tipoProdotto);
                      insertProdotto(prodotto);
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/aggiungiDeal');
                    }
                  },
                  style: CustomButtonStyle.outlinedButton,
                  child: const Text(Strings.conferma),
                ),
              ],
            ),
          ),
        )
    );
  }
}
