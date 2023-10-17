import 'dart:convert';

import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omc/common_widget/animated_dialog.dart';
import 'package:omc/common_widget/button_style.dart';
import 'package:omc/common_widget/common_widget.dart';
import 'package:omc/model/customer.dart';
import 'package:omc/model/debt.dart';
import 'package:omc/model/ordine.dart';

import 'package:omc/model/prodotto_ordine.dart';
import 'package:omc/util/colors.dart';
import 'package:omc/util/costants.dart';
import 'package:omc/util/strings.dart';

import 'common_widget/Input_decoration.dart';
import 'common_widget/common_function.dart';
import 'common_widget/input_field.dart';
import 'home_page.dart';

class RiepilogoOrdine extends StatefulWidget {
  const RiepilogoOrdine({Key? key}) : super(key: key);

  @override
  State<RiepilogoOrdine> createState() => _RiepilogoOrdineState();
}

enum OrdineChoice { debito, sconto }

class _RiepilogoOrdineState extends State<RiepilogoOrdine> {

  List<Customer> customerList = [];
  List<String> customersNames = [];
  OrdineChoice? _choice = OrdineChoice.debito;

  @override
  void initState() {
    super.initState();
    getCustomers();
  }

  Future<void> insertCustomer(Customer customer) async {
    const platform = MethodChannel('com.example.omc/customer');
    String newCustomerString = await platform.invokeMethod('insert_customer', {
      'customer': customer.toJson(),
    });

    Customer newCustomer = Customer.fromJson(jsonDecode(newCustomerString));
    setState(() {
      customerList.add(newCustomer);
      customersNames.add(newCustomer.nome);
    });

  }

  Future<void> insertOrdine(Ordine ordine, debitoOrSconto) async {
    int flagDebito = 2; // Inizializzo con 2 (significa che l'ordine è stato pagato interamente)

    if(debitoOrSconto != null){
      flagDebito = debitoOrSconto.index;
    }



    const platform = MethodChannel('com.example.omc/ordine');
    await platform.invokeMethod('insert_ordine', {
      'ordine': ordine.toJson(),
      'flagDebito' : flagDebito
    });

  }
  
  void getCustomers() async {
    const platform = MethodChannel('com.example.omc/customer');
    List<dynamic> customersStringList = await platform.invokeMethod('get_all_customer');

    for (String json in customersStringList) {
      final customer = Customer.fromJson(jsonDecode(json));
      customerList.add(customer);
      customersNames.add(customer.nome);
    }

    return ;
  }

  Customer? clienteSelezionato;
  double? costoTotale;


  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _key = GlobalKey<FormState>();
    final GlobalKey<FormState> _keyFormCustomer = GlobalKey<FormState>();
    final List<ProdottoOrdine> prodottiOrdine = ModalRoute.of(context)!.settings.arguments as List<ProdottoOrdine>;
    final TextEditingController _importoPagatoFieldController = TextEditingController(text: costoTotale.toString());
    final TextEditingController _customerController = TextEditingController();
    final TextEditingController _customerNameController = TextEditingController();
    costoTotale = CommonFunction().calcolaTotaleDovuto(prodottiOrdine);

    late final Widget _importoPagatoField;

    _importoPagatoField = CommonWidget().incDecInput(_importoPagatoFieldController, costoTotale!);
   // _importoPagatoField = InputField(label: Strings.importoRientrato,controller: _importoPagatoFieldController, obscure: false, integer: true, validatorFunc: (value) => importoRientratoValidator(value!));
    CustomInputDecoration cInputDecoration =  CustomInputDecoration(label: Strings.cliente ,icon: const Icon(Icons.person_rounded));

    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: CommonFunction().customAppBar(Strings.riepilogoOrdine),
        floatingActionButton: FloatingActionButton(
          backgroundColor: clienteSelezionato == null ? AppColors.secondary : AppColors.highlight,
          child: Icon(clienteSelezionato == null ? Icons.cancel : Icons.verified),
          onPressed: (){
            if(_key.currentState!.validate()){
              double importoPagatoDouble = double.parse(_importoPagatoFieldController.text);
              double debito = costoTotale! - importoPagatoDouble;
              if(importoPagatoDouble < costoTotale!){
                return showDialogOrdineChoice(debito, _importoPagatoFieldController, prodottiOrdine);
              }
              Ordine ordine = Ordine(
                  0,
                  prodottiOrdine,
                  costoTotale!,
                  double.parse(_importoPagatoFieldController.text),
                  DateTime.now().millisecondsSinceEpoch,
                  clienteSelezionato,
                  null
              );
              insertOrdine(ordine, null);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (BuildContext context) => HomePage(), // Sostituire con la tua schermata iniziale
                ),
                    (route) => false, // Questo parametro indica se tutte le rotte dovrebbero essere rimosse, quindi impostalo su false
              );
            }
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
               Padding(
               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
               child: Container(
                 decoration: BoxDecoration(
                   color: clienteSelezionato == null ? AppColors.secondary : AppColors.highlight,
                   borderRadius: BorderRadius.circular(20.0),
                 ),
                 constraints: BoxConstraints.expand(
                   height: Theme.of(context).textTheme.headlineMedium!.fontSize! * 1.1 + 100.0,
                 ),
                 padding: const EdgeInsets.all(8.0),
                 alignment: Alignment.center,
                 child: Text(clienteSelezionato == null ? Strings.nessunClienteSelezionato : '${Strings.cliente}: ${clienteSelezionato?.nome}',
                     style: Theme.of(context)
                         .textTheme
                         .headlineMedium!
                         .copyWith(color: Colors.white)),
                 )
               ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Form(
                      key: _key,
                      child:  Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                        padding: const EdgeInsets.all(10),
                                        alignment: Alignment.center,
                                        child: EasyAutocomplete(
                                          validator: (value) => clienteSelezionatoValidator(),
                                          inputTextStyle: const TextStyle(fontWeight: FontWeight.bold),
                                          decoration: cInputDecoration.borderInput ,
                                          controller: _customerController,
                                          suggestions: customersNames,
                                          suggestionBuilder: (data) {
                                            return Container(
                                                margin: const EdgeInsets.all(5),
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    color: AppColors.highlight,
                                                    borderRadius: BorderRadius.circular(5)
                                                ),
                                                child: Text(
                                                    data,
                                                    style: const TextStyle(
                                                        color: AppColors.background,
                                                        fontWeight: FontWeight.bold
                                                    )
                                                )
                                            );
                                          },
                                          onSubmitted: (nomeCliente) => {
                                            setClienteSelezionato(nomeCliente)
                                          },
                                        )
                                    )
                                ),
                                OutlinedButton(
                                  style: CustomButtonStyle.outlinedButton,
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                              title: const Center(
                                                child: Text(Strings.aggiungiCliente),
                                              ),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Form(
                                                      key: _keyFormCustomer,
                                                      child: InputField(label: Strings.nome, obscure: false, controller: _customerNameController, validatorFunc: (val) => nomeCustomerValidator(val))
                                                  ),
                                                  OutlinedButton(
                                                      style: CustomButtonStyle.outlinedButton,
                                                      onPressed: (){
                                                        if(_keyFormCustomer.currentState!.validate()){
                                                          Customer c = Customer(0, _customerNameController.text, null);
                                                          setState(() {
                                                            insertCustomer(c);
                                                            Navigator.pop(context);
                                                          });

                                                        }
                                                      },
                                                      child: const Center(
                                                        child:Text(Strings.conferma) ,
                                                      )
                                                  ),
                                                  OutlinedButton(
                                                      style: CustomButtonStyle.outlinedButton,
                                                      onPressed: (){
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Center(
                                                        child:Text(Strings.annulla) ,
                                                      )
                                                  )
                                                ],
                                              )
                                          );
                                        }
                                    );
                                    //Navigator.pushNamed(context, '/creaCustomer', arguments: customerList);
                                  },
                                  child: const Icon(Icons.person_add_alt_1),
                                ),
                              ],
                            ),
                          ),
                          _importoPagatoField
                        ],
                      )
                  )
              ),

              // La ListView con elementi scorrevoli
              ListView.builder(
                itemCount: prodottiOrdine.length,
                itemBuilder: (BuildContext context, int index) {
                  ProdottoOrdine pOrdine = prodottiOrdine[index];
                  return Card(
                    elevation: 5,
                    child: ListTile(
                      onTap: (){
                      },
                      leading: CircleAvatar(
                          backgroundColor: AppColors.highlight,
                          child: Text(pOrdine.prodottoDeal.prodotto.tipoProdotto.descrizione[0], style: const TextStyle(color: AppColors.headline),)
                      ),
                      title: Text(pOrdine.prodottoDeal.prodotto.nomeProdotto),
                      subtitle: Text(
                          returnCostoTotale(pOrdine.prodottoDeal.prezzoDettaglio, pOrdine.quantitativoPrevisto).toString() + Strings.currency
                      ),
                    ),
                  );
                },
                shrinkWrap: true, // Per consentire alla ListView di adattarsi all'altezza dei suoi elementi
                physics: const NeverScrollableScrollPhysics(), // Disabilita lo scorrimento della ListView
              ),

            ],
          ),
        )
      ),
    );
  }

  void setClienteSelezionato(String nome){
    Customer selezionato = customerList.firstWhere((element) => element.nome == nome);
    setState(() {
      clienteSelezionato = selezionato;
    });
  }

  String? nomeCustomerValidator(String? nomeCustomer){
    if(nomeCustomer!.isEmpty){
      return 'Inserire un nome appropriato';
    }

    Iterable<Customer> filtered = customerList.where((c) => c.nome == nomeCustomer);
    if(filtered.isNotEmpty){
      return 'Nome già in uso . Si prega di scegliere un\' altro nome per il cliente.';
    }
    return null;
  }
  String? clienteSelezionatoValidator(){
    return clienteSelezionato == null ? Strings.selezionareUnCliente : null;
  }

  String? importoRientratoValidator(String importo){
    double importoDouble = double.parse(importo);
    if(importoDouble > costoTotale!){
      return Strings.importoSuperioreTotale;
    }
    return null;
  }
  double returnCostoTotale(double prezzo , double quantita){
    return prezzo * quantita;
  }

  void showDialogOrdineChoice(double debito , _importoPagatoFieldController , prodottiOrdine){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AnimatedDialog(
            title: '${clienteSelezionato!.nome} ti deve ancora  ${debito} ${Strings.currency}',
            widgets: [
              StatefulBuilder(
                builder: (BuildContext builderContext, StateSetter setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text('Crea un debito'),
                        leading: Radio<OrdineChoice>(
                          activeColor: AppColors.highlight,
                          value: OrdineChoice.debito,
                          groupValue: _choice,
                          onChanged: (OrdineChoice? value) {
                            setState(() {
                              _choice = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Fai uno sconto'),
                        leading: Radio<OrdineChoice>(
                          activeColor: AppColors.highlight,
                          value: OrdineChoice.sconto,
                          groupValue: _choice,
                          onChanged: (OrdineChoice? value) {
                            setState(() {
                              _choice = value;
                            });
                          },
                        ),
                      ),
                      OutlinedButton(
                        onPressed: (){
                          Ordine ordine = Ordine(
                              0,
                              prodottiOrdine,
                              costoTotale!,
                              double.parse(_importoPagatoFieldController.text),
                              DateTime.now().millisecondsSinceEpoch,
                              clienteSelezionato,
                              null
                          );
                          insertOrdine(ordine, _choice);
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (BuildContext context) => HomePage(), // Sostituire con la tua schermata iniziale
                            ),
                                (route) => false, // Questo parametro indica se tutte le rotte dovrebbero essere rimosse, quindi impostalo su false
                          );

                        },
                        style: CustomButtonStyle.outlinedButton,
                        child: const Text(Strings.conferma),
                      )
                    ],
                  );
                },
              ),
            ]
        );
      },
    );
  }
}




