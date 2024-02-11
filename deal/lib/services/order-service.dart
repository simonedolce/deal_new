import 'package:deal/dao/order-dao.dart';
import 'package:deal/services/product-service.dart';

import '../model/customer.dart';
import '../model/order-product.dart';
import '../model/order.dart';
import '../model/product.dart';
import 'customer-service.dart';

class OrderService extends OrderDao {
  ProductService productService = ProductService();
  CustomerService customerService = CustomerService();

  static const int productTypeMode =  0;
  static const int customerTypeMode = 1;

  static const String infoMapKeyMP = 'miglior_prodotto';
  static const String infoMapKeyCA = 'cliente_affezionato';
  static const String infoMapKeyTR = 'totale_rientrato';
  static const String infoMapKeyTV = 'totale_venduto';

  Map<String, dynamic> informazioniOrdini(List<Orders> allOrdini){
    Map<String, dynamic> info = {};

    Map<dynamic, double> classificaProdotto = classifica(allOrdini, productTypeMode);
    Map<dynamic, double> classificaCliente = classifica(allOrdini, customerTypeMode);

    Product migliorProdotto = classificaProdotto.entries.toList().first.key as Product;
    Customer clienteAffezionato = classificaCliente.entries.toList().first.key as Customer;

    info[infoMapKeyMP] = migliorProdotto.nomeProdotto;
    info[infoMapKeyCA] = clienteAffezionato.name;
    info[infoMapKeyTR] = '${totaleRientrato(allOrdini)}€';
    info[infoMapKeyTV] = '${totaleVenduto(allOrdini)}€';

    return info;

  }

  double totaleVenduto(List<Orders> allOrdini){
    double totaleVenduto = 0;

    for (Orders order in allOrdini) {
      totaleVenduto += order.getTotale();
    }

    return totaleVenduto;
  }

  double totaleRientrato(List<Orders> allOrdini){
    double totaleRientrato = 0;

    for (Orders order in allOrdini) {
      totaleRientrato += order.getTotaleRientrato();
    }

    return totaleRientrato;
  }


  Map<dynamic, double> classifica(List<Orders> allOrdini, int object){

    Map<dynamic, double> toReturn = {};

    Map<int, double> classificaId = {};

    for (Orders order in allOrdini) {
      for (OrderProduct orderProduct in order.prodottiOrdine) {

        int id = 0;

        if(object == productTypeMode){
          id = orderProduct.productDeals.target!.product.target!.id;
        } else if(object == customerTypeMode){
          id = orderProduct.order.target!.customer.target!.id;
        }

        if(classificaId.containsKey(id)){
          double corrente = classificaId[id]!;
          classificaId[id] = corrente += orderProduct.quantitativoPrevisto;
        } else {
          classificaId[id] = orderProduct.quantitativoPrevisto;
        }
      }
    }

    Map<int, double> sorted = Map.fromEntries(
        classificaId.entries.toList()..sort((e1, e2) => e1.value.compareTo(e2.value)));


    sorted.entries.toList().reversed.forEach((element) {
      if(object == productTypeMode){
        Product product = productService.box.get(element.key)!;
        toReturn[product] = element.value;
      } else if(object == customerTypeMode){
        Customer customer = customerService.box.get(element.key)!;
        toReturn[customer] = element.value;
      }
    });


    return toReturn;

  }




}