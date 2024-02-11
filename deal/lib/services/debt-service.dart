import 'package:deal/dao/debt-dao.dart';
import 'package:deal/model/customer.dart';
import 'package:deal/model/debt.dart';
import 'package:deal/model/sanamento-debt.dart';
import 'package:deal/services/customer-service.dart';
import 'package:deal/services/sanamento-service.dart';

class DebtService extends DebtDAO {

  CustomerService customerService = CustomerService();
  SanamentoService sanamentoService = SanamentoService();

  static const String infoMapKeyTD = 'totale_debito';
  static const String infoMapKeyCI = 'cliente_indebitato';

  Map<String , dynamic> informazioniDebiti(List<Debt> allDebiti){
    Map<String, dynamic> info = {};
    info[infoMapKeyTD] = totaleDebitoAttivo(allDebiti).toString();
    Customer customer = classificaClientiIndebitati(allDebiti).entries.toList().first.key;
    info[infoMapKeyCI] = customer.name;
    return info;
  }

  Map<Customer, double> classificaClientiIndebitati(List<Debt> allDebiti){
    Map<int, double> idClassifica = {};
    Map<Customer, double> toReturn = {};

    for(Debt debito in allDebiti){

      int idCustomer = debito.order.target!.customer.target!.id;

      double totaleDebito = debito.totaleRimastoDaPagare();


      if(idClassifica.containsKey(idCustomer)){
        double totale = idClassifica[idCustomer]!;
        idClassifica[idCustomer] = totale += totaleDebito;
      } else {
        idClassifica[idCustomer] = totaleDebito;
      }

    }

    Map<int, double> sorted = Map.fromEntries(
        idClassifica.entries.toList()..sort((e1, e2) => e1.value.compareTo(e2.value)));

    sorted.entries.toList().reversed.forEach((element) {
      Customer customer = customerService.box.get(element.key)!;
      toReturn[customer] = element.value;
    });

    return toReturn;
  }

  double totaleDebitoAttivo(List<Debt> allDebiti){
    double totale = 0;

    for (Debt debito in allDebiti) {
        double totaleDebito = debito.importoDebito;

        if(debito.sanamenti.isNotEmpty){
          for (SanamentoDebt sanamento in debito.sanamenti) {
            totaleDebito -= sanamento.importoSanamento!;
          }
        }

        totale += totaleDebito;
    }

    return totale;

    }

  void aggiungiSanamento(SanamentoDebt sanamentoDebt, Debt debt) {
    debt.sanamenti.add(sanamentoDebt);

    bool debitoSanato = debt.isSanato();

    if(debitoSanato){
      debt.isAttivo = false;
    }

    put(debt);

  }

}