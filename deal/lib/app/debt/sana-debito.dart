import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:deal/model/sanamento-debt.dart';
import 'package:deal/services/debt-service.dart';
import 'package:deal/services/sanamento-service.dart';
import 'package:deal/util/colors.dart';
import 'package:deal/util/deal-styles.dart';
import 'package:deal/util/text-styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import '../../model/customer.dart';
import '../../model/debt.dart';
import '../../model/order.dart';
import '../../util/routes.dart';

class SanaDebito extends StatefulWidget {
  final Customer customer;

  const SanaDebito({super.key, required this.customer});

  @override
  State<SanaDebito> createState() => _SanaDebitoState();
}

class _SanaDebitoState extends State<SanaDebito> {

  late Customer customer;
  late List<Debt> debitiAttivi;
  SanamentoService sanamentoService = SanamentoService();
  DebtService debtService = DebtService();
  TextEditingController importoSanamentoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    customer = widget.customer;
    debitiAttivi = ritornaDebitiAttivi();
  }

  List<Debt> ritornaDebitiAttivi(){
    List<Debt> debiti = [];

    for(Orders ordini in customer.ordini) {
      if(ordini.debito.hasValue){
        if(ordini.debito.target!.isAttivo){
          debiti.add(ordini.debito.target!);
        }
      }
    }

    return debiti;
  }

  void showBottomSheet(){
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,

      builder: (BuildContext context) {
        return StatefulBuilder(

            builder: (BuildContext context, StateSetter setState) {
              return Padding(

                  padding: EdgeInsets.all(16.0),

                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    importoSanamentoController.text = customer.totaleDebitoDovuto().toString();
                                  });
                                },
                                child: const Text('Copri al 100%')
                            ),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    importoSanamentoController.text = 0.toString();
                                  });
                                },
                                child: Text('Azzera')
                            )
                          ],
                        ),
                        NumberInputWithIncrementDecrement (
                          controller: importoSanamentoController,
                          initialValue: 0,
                          min: 1,
                          max: customer.totaleDebitoDovuto(),
                          onChanged: (num val) {
                            importoSanamentoController.text = val.toString();
                          },
                        ),
                        TextButton(
                            onPressed: () {

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
                                desc:
                                "Si procederà con il sanamento del/dei debito/debiti per un importo totale di ${importoSanamentoController.text} € . Continuare?",
                                btnCancelOnPress: () {},
                                onDismissCallback: (type) {
                                  debugPrint('Dialog Dismiss from callback $type');
                                },
                                btnOkOnPress: () {
                                  sanaDebiti(double.parse(importoSanamentoController.text));
                                  Navigator.pushNamed(context, RoutesDef.dashBoard);
                                },
                              ).show();



                            },
                            child: const Text('Conferma')
                        )

                      ],

                    ),
                  )

              );
            });


      },

    );
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Debiti di ${customer.name}', style: DealTextStyles(fontName: 'mosteraRegular').textStyleDark), backgroundColor: CommonColors.background),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: CommonColors.primary,
                borderRadius: BorderRadius.all(Radius.circular(20)),

              ),
              child: Wrap(
                direction: Axis.vertical,
                children: [
                  Text('Totale dovuto : ${customer.totaleDebitoDovuto()} €', style: DealTextStyles(fontSize: 16).textStyleDark),
                  OutlinedButton(
                      onPressed: () {
                        showBottomSheet();
                      },
                      child: Text('Inserisci sanamento')
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text('Ordini non pagati'),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    Debt debito = debitiAttivi.elementAt(index);
                    return ListTile(
                      leading: FaIcon(FontAwesomeIcons.moneyBill),
                      title: Text('${debito.totaleRimastoDaPagare()}€'),
                      subtitle: Text(debito.order.target!.getDataCreazione()),
                      tileColor: CommonColors.secondary,
                      shape: DealStyles.roundRectangleRadiusBorder,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  itemCount: debitiAttivi.length
              ),
            ),

          ],
        )
      ),
      resizeToAvoidBottomInset: true,
    );
  }


  void sanaDebiti(double importoSanamento) {

    for(Debt debito in debitiAttivi) {
      if(importoSanamento <= 0) break;
      double totaleRimasto = debito.totaleRimastoDaPagare();

      SanamentoDebt sanamentoDebt = SanamentoDebt();
      sanamentoDebt.debt.target = debito;

      if(importoSanamento >= totaleRimasto) {
        debito.isAttivo = false;
        sanamentoDebt.importoSanamento = totaleRimasto;
      }

      if(importoSanamento < totaleRimasto) {
        sanamentoDebt.importoSanamento = importoSanamento;
      }

      importoSanamento = importoSanamento - totaleRimasto;

      sanamentoService.put(sanamentoDebt);
      debito.sanamenti.add(sanamentoDebt);
      debtService.put(debito);
    }
  }

}
