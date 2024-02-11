import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:deal/model/debt.dart';
import 'package:deal/model/sanamento-debt.dart';
import 'package:deal/services/debt-service.dart';
import 'package:deal/services/sanamento-service.dart';
import 'package:deal/util/colors.dart';
import 'package:deal/util/deal-button-styles.dart';
import 'package:deal/util/text-styles.dart';
import 'package:flutter/material.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import '../../util/routes.dart';

class InserisciSanamento extends StatefulWidget {

  final Debt debt;

  const InserisciSanamento({super.key, required this.debt});

  @override
  State<InserisciSanamento> createState() => _InserisciSanamentoState();
}

class _InserisciSanamentoState extends State<InserisciSanamento> {

  final GlobalKey<FormState> _sanamentoForm = GlobalKey<FormState>();
  late Debt debt;
  late double totaleRimasto;

  SanamentoDebt sanamentoDebt = SanamentoDebt();

  SanamentoService sanamentoService = SanamentoService();
  DebtService debtService = DebtService();

  TextEditingController controllerImporto = TextEditingController();

  @override
  void initState() {
    super.initState();
    debt = widget.debt;
    totaleRimasto = debt.totaleRimastoDaPagare();
  }

  String? checkImportoSanamento(String importo){
    double importoDouble = double.parse(importo);
    String? error;

    if(importoDouble <= 0) {
      error = "L'importo non può essere inferiore o uguale a zero";
    }

    if(importoDouble > debt.importoDebito){
      error = "L'importo non può essere maggiore dell'importo debito";
    }

    if(error != null){
      return error;
    }

    return null;

  }

  Widget formSanamento() {
    return Form(
      key: _sanamentoForm,
      child: Wrap(
        runSpacing: 10,
        children: [
          Text(
              'Importo Sanamento:' ,
              style: DealTextStyles().textStyleDark
          ),
          NumberInputWithIncrementDecrement(
            controller: controllerImporto,
            validator: (value) => checkImportoSanamento(value!),
            min: 0,
            max: debt.importoDebito,
            autovalidateMode: AutovalidateMode.disabled,
            initialValue: 0,
            onIncrement: (value){
              setState(() {
                sanamentoDebt.importoSanamento = value.toDouble();
                totaleRimasto = debt.totaleRimastoDaPagare() - value.toDouble();
                if(value == 0){
                  totaleRimasto = debt.totaleRimastoDaPagare();
                }

              });
            },
            onDecrement: (value){
              setState(() {
                sanamentoDebt.importoSanamento = value.toDouble();
                totaleRimasto = debt.totaleRimastoDaPagare() - value.toDouble();
                if(value == 0){
                  totaleRimasto = debt.totaleRimastoDaPagare();
                }
              });
            },
            onChanged: (value) {
              sanamentoDebt.importoSanamento = value.toDouble();
              totaleRimasto = debt.totaleRimastoDaPagare() - value.toDouble();
              if(value == 0){
                totaleRimasto = debt.totaleRimastoDaPagare();
              }
            },
          ),
          ElevatedButton(
              onPressed: () {
                if(_sanamentoForm.currentState!.validate()){
                  double importoSanamento = double.parse(controllerImporto.text);
                  bool copertoTotale = importoSanamento == debt.totaleRimastoDaPagare();
                  double nuovoRimasto = copertoTotale ? 0 : debt.totaleRimastoDaPagare() - importoSanamento;

                  String text = copertoTotale ?
                      "Il debito sarà sanato completamente" : "Rimangono ancora ${nuovoRimasto}€";

                  AwesomeDialog(
                    context: context,
                    customHeader: Image.asset('images/char.png'),

                    dialogType: DialogType.warning,
                    headerAnimationLoop: false,
                    animType: AnimType.rightSlide,
                    showCloseIcon: true,
                    closeIcon: const Icon(Icons.dangerous_rounded),
                    title: 'Attenzione!',
                    titleTextStyle: const TextStyle(fontFamily: 'bold'),
                    descTextStyle: const TextStyle(fontFamily: 'regular'),
                    desc:'Si procedera con il sanamento del debito \n ${text}',
                    btnCancelOnPress: () {},
                    onDismissCallback: (type) {
                      debugPrint('Dialog Dismiss from callback $type');
                    },
                    btnOkOnPress: () {
                      sanamentoDebt.dataSanamento = DateTime.now();
                      sanamentoService.put(sanamentoDebt);

                      debtService.aggiungiSanamento(sanamentoDebt, debt);
                      Navigator.popAndPushNamed(context, RoutesDef.dashBoard);
                    },
                  ).show();
                }
              },
              style: DealButtonStyles.elevatedButton,
              child: const Text('Conferma')
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: CommonColors.background, title:
      Text(
          'Sanamento',
          style: DealTextStyles(
                    fontName: DealTextStyles.mostera,
                    fontSize: 20
                    ).textStyleDark
      )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          runSpacing: 20,
          children: [
            formSanamento(),
            Container(
              padding: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: CommonColors.paragraph,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(offset: Offset(5, 5))
                ]
              ),
              child:  Wrap(
                direction: Axis.vertical,
                spacing: 10,
                children: [
                   const Text(
                    'Informazioni debito:',
                    style: TextStyle(fontSize: 25, fontFamily: 'bold'),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Cliente: ${debt.order.target!.customer.target!.name}',
                    style: const TextStyle(fontSize: 15, fontFamily: 'regular'),
                  ),
                  Text(
                    "Ordine del: ${debt.order.target!.getDataCreazione()}",
                    style: const TextStyle(fontSize: 15, fontFamily: 'regular'),
                  ),
                  Text(
                    "Totale dovuto sull'ordine: ${debt.order.target!.totale} €",
                    style: const TextStyle(fontSize: 15, fontFamily: 'regular'),
                  ),
                  Text(
                    'Importo iniziale debito: ${debt.importoDebito} €',
                    style: const TextStyle(fontSize: 15, fontFamily: 'regular'),
                  ),
                  totaleRimasto > 0 ?
                  Text(
                    'Totale rimasto: ${totaleRimasto} €',
                    style: const TextStyle(fontSize: 15, fontFamily: 'regular'),
                  ) :
                  Text(
                    'Debito Sanato!',
                    style: const TextStyle(fontSize: 15, fontFamily: 'bold'),
                  )
                  ,
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}
