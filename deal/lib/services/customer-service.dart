import 'package:deal/dao/customer-dao.dart';
import 'package:deal/model/order.dart';
import 'package:deal/services/debt-service.dart';

import '../model/customer.dart';
import '../model/debt.dart';

class CustomerService extends CustomerDao {

  /// Trova il numero di ordine di un cliente
  int trovaProgressivoOrdine(Orders ordine){
    Customer customer = ordine.customer.target!;
    int progressivo = 0;

    for (Orders orderCustomer in customer.ordini) {
      progressivo++;
      if(orderCustomer.id == ordine.id){
        break;
      }
    }

    return progressivo;
  }

  List<Customer> getListaCustomerIndebitati(){
    return customerConDebiti();
  }

}