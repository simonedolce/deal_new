import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:deal/main.dart';
import 'package:deal/model/customer.dart';
import 'package:deal/services/customer-service.dart';
import 'package:deal/util/colors.dart';
import 'package:deal/util/deal-input-decorator.dart';
import 'package:deal/util/deal-styles.dart';
import 'package:flutter/material.dart';

class CreaCustomer extends StatefulWidget {
  const CreaCustomer({super.key});

  @override
  State<CreaCustomer> createState() => _CreaCustomerState();
}

class _CreaCustomerState extends State<CreaCustomer> {
  Customer customer = Customer();
  CustomerService customerService = CustomerService();

  TextEditingController nomeController = TextEditingController();
  final GlobalKey<FormState> keyFormCustomer = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crea Cliente', style: DealStyles.mostera), backgroundColor: CommonColors.background),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          left: 20,
          right: 20
        ),
        child: Center(
          child: Form(
            key: keyFormCustomer,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: DealStyles.dealRadius,
                  color: CommonColors.primary2
              ),
              child: Wrap(
                runSpacing: 20,
                children: [
                  Wrap(
                    runSpacing: 10,
                    children: [
                      Text('Nome del cliente', style: DealStyles.regular),
                      TextFormField(
                        decoration: DealInputDecorator(label: 'Nome').dealInputDecorator,
                        controller: nomeController,
                        validator: (value) => validaNome(value),
                      ),

                    ],
                  ),

                  AnimatedButton(
                    text: 'Inserisci',
                    color: CommonColors.primary,
                    pressEvent: () {
                      if(keyFormCustomer.currentState!.validate()){
                        customer.name = nomeController.text;
                        customerService.put(customer);
                        Navigator.pop(context);
                      }
                    },
                  )
                ],
              ),
            )
          ),
        )
      ),
    );
  }

  String? validaNome(String? value) {
    Customer? nomePresente = customerService.getCustomerByName(value!);

    if(value.isEmpty){
      return  'Inserire un valore';
    }

    if(nomePresente is Customer){
      return  'Nome già in uso';
    }


    return null;
  }
}
