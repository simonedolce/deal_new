import 'package:deal/services/customer-service.dart';
import 'package:deal/util/colors.dart';
import 'package:deal/util/deal-button-styles.dart';
import 'package:deal/util/deal-styles.dart';
import 'package:deal/util/routes.dart';
import 'package:deal/util/text-styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../model/customer.dart';
import '../../model/order.dart';
import '../../services/order-service.dart';

class ElencoOrdini extends StatefulWidget {
  const ElencoOrdini({super.key});

  @override
  State<ElencoOrdini> createState() => _ElencoOrdiniState();
}




class _ElencoOrdiniState extends State<ElencoOrdini> {
  late Stream<List<Orders>> ordiniStream;

  late List<Orders> ordiniList = [];
  late List<Customer> customerList = [];

  Customer? filterCustomer;
  bool filterConDebito = false;
  DateTimeRange? filterPeriodo;

  OrderService orderService = OrderService();
  CustomerService customerService = CustomerService();

  @override
  void initState() {
    super.initState();
    customerList = customerService.getAll();
    ordiniList = orderService.getAllFilter(filterCustomer,filterPeriodo,filterConDebito);
  }

  void showBottomFilter(){
    showModalBottomSheet(

      context: context,

      builder: (BuildContext context) {
        return StatefulBuilder(

          builder: (BuildContext context, StateSetter setState) {
            return Padding(

                padding: EdgeInsets.all(16.0),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(child: Text('Cliente')),
                        DropdownButton<Customer>(
                          hint: const Text('Seleziona un cliente'),
                          style: DealStyles.regular,
                          value: filterCustomer,
                          onChanged: (Customer? filteredCustomer) {
                            setState(() {
                              filterCustomer = filteredCustomer;
                            });
                          },
                          items: customerList.map((Customer customer) {
                            return DropdownMenuItem<Customer>(
                              value: customer,
                              child: Text(customer.name),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(child: Text('Con debito')),
                        Checkbox(
                            value: filterConDebito,
                            onChanged: (bool? value) {
                              setState(() {
                                filterConDebito = value!;
                              });
                            }
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(child: Text('Data ordine')),
                        calendarButtonFilter(),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(child: Text('Reset')),
                        TextButton(
                            onPressed: (){
                              setState(() {
                                deactivateFilters();
                              });
                            },
                            child: const Text('Reset')
                        )
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(child: Text('Applica filtri')),
                        TextButton(
                            onPressed: (){
                              Navigator.pop(context);
                              updateList();
                            },
                            child: const Text('Conferma')
                        )
                      ],
                    )

                  ],

                )

            );
          });


      },

    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Ordini', style: DealTextStyles(fontName: DealTextStyles.mostera).textStyleDark) , backgroundColor: CommonColors.background),

      body: Padding(
        padding: const EdgeInsets.only(right: 20,left: 20,bottom: 20),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: CommonColors.background,
              child: ElevatedButton(
                  onPressed: (){
                    showBottomFilter();
                  },
                  child:  Wrap(
                      children: [
                        Text('Filtra i risultati',style: DealTextStyles(fontName: 'bold',fontSize: 16).textStyleDark),
                        const FaIcon(FontAwesomeIcons.filter,color: CommonColors.black)
                      ]
                  )
              ),
            ),
            ordiniList.isNotEmpty ?
            Expanded(
                child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    reverse: true,
                    itemBuilder: (context, index) {
                      Orders ordine = ordiniList.elementAt(index);
                      return ListTile(
                        title: Text(ordine.customer.target!.name),
                        shape: DealStyles.roundRectangleRadiusBorder,
                        subtitle: Text('${ordine.totale}€'),
                        tileColor: CommonColors.primary,
                        leading: TextButton(
                            child: const Text('Apri'),
                            onPressed: () {
                              Navigator.pushNamed(context, RoutesDef.dettaglioOrdine, arguments: {'order': ordine});
                            }
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 10);
                    },
                    itemCount: ordiniList.length
                )
            )
                : const Center(child: Text('Nessun ordine da visualizzare'))

          ],
        ),
      )


    );
  }

  void updateList(){
    setState(() {
      ordiniList = orderService.getAllFilter(filterCustomer,filterPeriodo, filterConDebito);
    });
  }

  Widget calendarButtonFilter(){
    return IconButton(
      onPressed: () async {
        final picked = await showDateRangePicker(
          saveText: 'Conferma',
          context: context,
          lastDate: DateTime(2025),
          firstDate: DateTime(2024),
        );
        if (picked != null && picked != null) {
          // Setto a mezzanotte la fine per comprendere tutto il giorno
          final currentTime = picked.end;
          final midnight = currentTime.copyWith(hour: 23, minute: 59,second: 59);
          DateTimeRange dateTimeRange = DateTimeRange(start: picked.start, end: midnight);

          filterPeriodo = dateTimeRange;
          updateList();
        }
      },
      icon: const Icon(
        Icons.calendar_today,
        color: CommonColors.dark,
      ),
    );
  }

  void deactivateFilters(){
      filterCustomer = null;
      filterPeriodo = null;
      filterConDebito = false;
      updateList();
  }

  void setDebitoFilter(bool val){
    print(val);

  }


  Widget resetFilterCustomer(filter){
    return IconButton(
        onPressed: () {
          filterCustomer = null;
          updateList();
        },
        icon: const FaIcon(FontAwesomeIcons.deleteLeft, size: 15)
    );
  }

  Widget resetFilterPeriodo(filter){
    return IconButton(
        onPressed: () {
          filterPeriodo = null;
          updateList();
        },
        icon: const FaIcon(FontAwesomeIcons.deleteLeft, size: 15)
    );
  }


}
