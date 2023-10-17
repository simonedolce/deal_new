import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:omc/common_widget/button_style.dart';
import 'package:omc/model/customer.dart';
import 'package:another_stepper/another_stepper.dart';
import 'package:omc/model/debt.dart';
import 'package:omc/model/ordine.dart';
import 'package:omc/model/sanamento_debito.dart';
import 'package:omc/util/colors.dart';
import 'package:omc/util/strings.dart';

import 'common_widget/animated_dialog.dart';
import 'common_widget/common_function.dart';
import 'common_widget/input_field.dart';
import 'common_widget/number_stepper.dart';

class DettaglioDebiti extends StatefulWidget {
  const DettaglioDebiti({Key? key}) : super(key: key);


  @override
  State<DettaglioDebiti> createState() => _DettaglioDebitiState();

}

class _DettaglioDebitiState extends State<DettaglioDebiti> {
  bool visualizzaStoricoState = false;
  String textButton = Strings.visualizzaStorico;


  late double coperturaDebitoCorrente = 0;
  late Customer customer;
  late Map<int,dynamic> storico = creaStorico(visualizzaStoricoState);

  final GlobalKey<FormState> keyFormSanamento = GlobalKey<FormState>();
  final TextEditingController controllerImportoSanamento = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BuildContext widgetContext = context;
    customer = ModalRoute.of(context)!.settings.arguments as Customer;
    double totaleDebito = CommonFunction().getTotaleDebito(customer);
    List<StepperData> stepperStorico = createStepperList(storico);
    controllerImportoSanamento.text = coperturaDebitoCorrente.toString();


    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: CommonFunction().customAppBar("Dettaglio Debiti ${customer.nome}"),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.highlight,
          onPressed: (){
            mostraDialogSanamento(widgetContext,totaleDebito);
          }, // Apri la modal del carrello
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.monetization_on_rounded, size: 20),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                    children: [
                      OutlinedButton(
                        style: CustomButtonStyle.outlinedButton,
                          onPressed: (){
                            setState(() {
                              visualizzaStoricoState = visualizzaStoricoState == false ? true : false;
                              textButton = visualizzaStoricoState ? Strings.nascondiStorico : Strings.visualizzaStorico;
                              storico = creaStorico(visualizzaStoricoState);
                            });

                          },
                          child: Text(textButton, style: const TextStyle(fontFamily: 'medium'))
                      ),
                      Spacer(),
                      Text(
                          "Totale: ${totaleDebito}",
                          style: const TextStyle(fontSize: 20,color: AppColors.headline,fontFamily: 'medium')
                      ),
                    ]
                ),

                AnotherStepper(
                  stepperList: stepperStorico,
                  stepperDirection: Axis.vertical,
                  iconWidth: 40, // Height that will be applied to all the stepper icons
                  iconHeight: 40, // Width that will be applied to all the stepper icons
                ),


              ],
            ),
          )
        )
      )
    );

  }

  void mostraDialogSanamento(BuildContext mainContext, double totaleDebito){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AnimatedDialog(
              title: 'Fai un risanamento sui debiti (Totale: $totaleDebito ${Strings.currency})',
              widgets: [
                StatefulBuilder(
                    builder: (BuildContext builderContext, StateSetter setState) {
                      return Column(
                        children: [
                          Form(
                              key: keyFormSanamento,
                              child: Column(
                                  children: [
                                    InputField(
                                      label: "Importo risanamento",
                                      obscure: false,
                                      controller: controllerImportoSanamento,
                                      integer: true,
                                      maxValue: totaleDebito,
                                      onChanged: (value) {
                                        setState(() {
                                          coperturaDebitoCorrente = double.parse(value!);
                                        });
                                      },
                                    ),
                                    FAProgressBar(
                                      displayTextStyle: const TextStyle(color: Colors.black),
                                      progressColor: AppColors.headline,
                                      backgroundColor: AppColors.paragraph,
                                      displayText: ' % ',
                                      maxValue: 100,
                                      currentValue: calcolaPercentualeDebito(coperturaDebitoCorrente,totaleDebito), // Update this value
                                    ),
                                    OutlinedButton(
                                      onPressed: (){
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AnimatedDialog(
                                                title: 'Sei sicuro di voler fare un risanamento pari a $coperturaDebitoCorrente ${Strings.currency} ?',
                                                widgets:  [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribuisce lo spazio tra i children
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      const Spacer(),
                                                      OutlinedButton(
                                                        onPressed: (){},
                                                        style: CustomButtonStyle.outlinedButton,
                                                        child: const Text(Strings.annulla),
                                                      ),
                                                      const Spacer(),
                                                      OutlinedButton(
                                                          onPressed: (){
                                                            risanaDebito(coperturaDebitoCorrente);
                                                            Navigator.popAndPushNamed(mainContext, '/homePage');
                                                          },
                                                          style: CustomButtonStyle.outlinedButton,
                                                          child: const Text(Strings.conferma)
                                                      ),
                                                      const Spacer(),
                                                    ],

                                                  )
                                                ],
                                              );
                                            });
                                      },
                                      style: CustomButtonStyle.outlinedButton,
                                      child: Text("Risana"),

                                    )
                                  ]
                              )
                          )
                        ],
                      );
                    }
                )

              ]
          );
        }
    );
  }

  double calcolaPercentualeDebito(double importoCorrente , double debitoTotale){
    return (importoCorrente / debitoTotale) * 100;
  }

  /// Manipolo diversi tipi di oggetto (Ordine , Sanamenti)
  /// creando coppie DATA CREAZIONE : TIPO OGGETTO
  /// In modo da creare uno storico delle attività del cliente
  Map<int,dynamic> creaStorico(bool storicoBool) {

    Map<int,dynamic> storico = {};
    Map<int, dynamic> storicoSorted = {};

    if(customer.ordini != null) {
      Customer customerCopy = Customer.fromJson(customer.toJson());
      List<Ordine>? ordini = customerCopy.ordini;
      // Ciclo gli ordini indebitati del cliente

      for(Ordine ordine in ordini!){
        if(!storicoBool){
          if(!ordine.debito!.isAttivo) continue;
        }

        /*
          Mi ritrovo in una situazione in cui ho SOLO ordini con debiti , per semplicità
          recupero quindi il debito con la data dell'ordine (quindi anche del debito)
         */

        storico[ordine.dataOrdine] = ordine;

        List<SanamentoDebito>? sanamentiDebito = ordine.debito?.sanamenti;

        // Recupero eventuali sanamenti del debito
        for(SanamentoDebito sanamentoDebito in sanamentiDebito!){
          if(storico.containsKey(sanamentoDebito.dataSanamento)){

            storico.update(sanamentoDebito.dataSanamento, (value) {
              value.importoSanamento += sanamentoDebito.importoSanamento;
              return value;
            });

          } else {
            storico[sanamentoDebito.dataSanamento] = sanamentoDebito;
          }

        }

      }

      if(storicoBool){
        // Estraggo solo le date (timeStamps in questo caso) per riordinarle
        List<int> timeStamps = storico.keys.toList();
        timeStamps.sort();

        // Riordino nell'ultima mappa i valori della prima mappa
        for (int timeStamp in timeStamps) {
          storicoSorted[timeStamp] = storico[timeStamp];
        }

        return storicoSorted;
      }


    }

    return storico;

  }

  List<StepperData> createStepperList(Map<int,dynamic> storico){

    List<StepperData> stepperData = [];

    storico.forEach((key, value) {

      String tipoStorico;
      IconData icona;
      double? importo;
      String data;
      Color color;
      String operator;

      if(value is Ordine){
        Debt? debito = value.debito;
        tipoStorico = "Debito";
        importo = debito?.importoDebito;
        icona = Icons.payments_outlined;
        data = CommonFunction().fromTimeStampToDateHour(value.dataOrdine);
        color = AppColors.highlight;
        operator = "-";
      } else {
        SanamentoDebito sanamentoDebito = value;
        tipoStorico = "Sanamento";
        importo = sanamentoDebito.importoSanamento;
        icona = Icons.payments;
        data = CommonFunction().fromTimeStampToDateHour(sanamentoDebito.dataSanamento);
        color = AppColors.success;
        operator = "+";
      }

      stepperData.add(StepperData(
          title: StepperText("$data $tipoStorico",
          textStyle: const TextStyle(color: Colors.grey, fontFamily: 'mediumItalic')
          ),
          subtitle: StepperText("$operator $importo ${Strings.currency}" ,textStyle: TextStyle(color: color, fontFamily: 'medium')),
          iconWidget: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.all(Radius.circular(30))),
            child: Icon(icona, color: Colors.white),
          )
      ));
    });
    return stepperData;
  }

  void risanaDebito(double sanamentoDebito) {
    double pagamentoCliente = sanamentoDebito;
    DateTime now = DateTime.now();
    int timestamp = now.millisecondsSinceEpoch;
    Map<Ordine,double> ordineDebito = {};
    Customer customerCopy = Customer.fromJson(customer.toJson());
    List<Ordine>? ordini = customerCopy.ordini;

    for(Ordine ordine in ordini!){
      if(ordine.debito!.isAttivo){
        double importoDebitoOrdine = ordine.debito!.importoDebito;
        List<SanamentoDebito>? sanamentiDebitoOrdine = ordine.debito!.sanamenti;
        for(SanamentoDebito sanamentoDebitoOrdine in sanamentiDebitoOrdine!){
          importoDebitoOrdine -= sanamentoDebitoOrdine.importoSanamento;
        }
        ordineDebito[ordine] = importoDebitoOrdine;
      }
    }

    ordineDebito.forEach((ordine, counterDebito) {
      double importoSanamento = 0;
      if (pagamentoCliente >= counterDebito) {
        ordineDebito[ordine] = 0;
        pagamentoCliente -= counterDebito;
        importoSanamento = counterDebito;
        ordine.debito?.isAttivo = false;
      } else {
        ordineDebito[ordine] = (counterDebito - pagamentoCliente).clamp(0, counterDebito);
        importoSanamento = pagamentoCliente;
        pagamentoCliente = 0;
      }

      if(importoSanamento != 0){
        SanamentoDebito sanamentoDebitoObj = SanamentoDebito(0, importoSanamento, timestamp, null);
        ordine.debito?.sanamenti?.add(sanamentoDebitoObj);
      }


    });

    // Faccio la chiamata per aggiornare il cliente
    updateCustomer(customerCopy);


    
  }

  /// La chiamata all'api Java che aggiorna il cliente con
  /// le modifiche sui debiti / sanamenti
  Future<void> updateCustomer(Customer customerToUpdate) async {

    const platform = MethodChannel('com.example.omc/debt');

    try {
      await platform.invokeMethod('sanamento_debiti', {'customer': customerToUpdate.toJson()});
    } catch (e) {
      print('Errore durante la chiamata del metodo Java: $e');
    }
  }
}
