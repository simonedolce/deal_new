import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:deal/dao/customer-dao.dart';
import 'package:deal/main.dart';
import 'package:deal/model/deal-product.dart';
import 'package:deal/model/debt.dart';
import 'package:deal/services/customer-service.dart';
import 'package:deal/services/deal-product-service.dart';
import 'package:deal/services/debt-service.dart';
import 'package:deal/services/order-service.dart';
import 'package:deal/util/colors.dart';
import 'package:deal/util/deal-styles.dart';
import 'package:deal/util/routes.dart';
import 'package:flutter/material.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

import '../../model/customer.dart';
import '../../model/order.dart';

class AcquistoCliente extends StatefulWidget {
  const AcquistoCliente({super.key, required this.order});
  final Orders order;

  @override
  State<AcquistoCliente> createState() => _AcquistoClienteState();
}

class _AcquistoClienteState extends State<AcquistoCliente> {

  late Orders order;
  late Stream<List<Customer>> streamCustomers;
  late List<Customer> customers = [];
  late Customer? customerSelezionato;
  late TextEditingController totalePagatoController;

  CustomerService customerService = CustomerService();
  DealProductService dealProductService = DealProductService();
  DebtService debtService = DebtService();
  OrderService orderService = OrderService();

  @override
  void initState() {
    super.initState();
    streamCustomers = customerService.getAllStream();
    order = widget.order;
    totalePagatoController = TextEditingController();
    customerSelezionato = Customer();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, RoutesDef.creaCustomer);
            },
            child: const Text('Crea Cliente')
        ),
        ElevatedButton(
            onPressed: () {
              if(customerSelezionato!.name.isNotEmpty){
                double totaleDaPagare = order.getTotale();
                double totalePagato = double.parse(totalePagatoController.text);

                bool hasDebito = totaleDaPagare > totalePagato;
                double importoDebito = 0;
                if(hasDebito){
                  importoDebito = totaleDaPagare - totalePagato;
                }

                order.totale = totaleDaPagare;
                order.totalePagato = totalePagato;

                String messageText = hasDebito ?
                "Si procederà con il salvataggio dell'ordine. ${customerSelezionato!.name} ti deve ancora ${importoDebito} €" :
                "Si procederà con il salvataggio dell'ordine.";

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
                  desc:messageText,
                  btnCancelOnPress: () {},
                  onDismissCallback: (type) {
                    debugPrint('Dialog Dismiss from callback $type');
                  },
                  btnOkOnPress: () {
                    if(hasDebito){
                      Debt debito = Debt(importoDebito: importoDebito, isAttivo: true);
                      debito.order.target = order;

                      debtService.put(debito);
                      order.debito.target = debito;
                    }

                    order.customer.target = customerSelezionato;


                    order.prodottiOrdine.forEach((element) {
                      DealProduct productDeal = element.productDeals.target!;
                      productDeal.disponibilitaMercato =  productDeal.disponibilitaMercato - element.quantitativoEffetivo;
                      dealProductService.put(productDeal);
                      element.order.target = order;
                    });

                    orderService.put(order);
                    customerSelezionato?.ordini.add(order);
                    customerService.put(customerSelezionato);
                    Navigator.popAndPushNamed(context, RoutesDef.dashBoard);
                  },
                ).show();
              }

            },
            child: const Text('Conferma Ordine')
        ),

      ],
      appBar: AppBar(title: Text('Scegli il cliente', style: DealStyles.mostera), backgroundColor: CommonColors.background),
      body:  Padding(
        padding: const EdgeInsets.only(
            top: 10,
            right: 20,
            left: 20
        ),
        child: customers.isNotEmpty ? const Text('Non sono presenti clienti') :
            Column(
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: StreamBuilder<List<Customer>>(
                      stream: streamCustomers,
                      builder: (BuildContext context, AsyncSnapshot<List<Customer>> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: Text('Non ci sono clienti')
                          );
                        } else {
                          final List<Customer>? customers = snapshot.data;
                          return Container(
                            height: MediaQuery.of(context).size.height / 2,
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              color: CommonColors.background,
                              shape: BoxShape.rectangle,
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {

                                Customer? customer = customers.elementAt(index);

                                return Card(
                                  shape: DealStyles.roundRectangleRadiusBorder,
                                  color:  customerSelezionato == customer ? CommonColors.secondary : CommonColors.primary,
                                  child: ListTile(
                                    title: Text(customer!.name),
                                    subtitle: Text(''),
                                    onTap: () => setState(() {
                                      if(customerSelezionato == customer){
                                        customerSelezionato = Customer();
                                      } else {
                                        customerSelezionato = customer;
                                      }

                                    }),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => const SizedBox(height: 10), itemCount: customers!.length,
                            ),
                          );
                        }
                      }),
                ),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: CommonColors.secondary
                  ),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      Text('Totale : ${order.getTotale()} €', style: DealStyles.bold),
                      const SizedBox(height: 10),
                      Text('Quantita : ${order.getQuantitaTotale()} gr',style: DealStyles.bold),
                      const SizedBox(height: 10),
                      const Text('Totale ricevuto (in €) :'),
                      NumberInputWithIncrementDecrement(
                        controller: totalePagatoController,
                        initialValue: order.getTotale(),
                        fractionDigits: 1,
                        incDecFactor: 0.5,
                        max: order.getTotale(),
                      )
                    ],
                  ),
                )
              ],
            )


      ),
    );
  }
}
