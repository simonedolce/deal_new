import 'package:deal/model/deal-product.dart';
import 'package:deal/model/debt.dart';
import 'package:deal/model/order-product.dart';
import 'package:deal/model/order.dart';
import 'package:deal/model/sanamento-debt.dart';
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Deal  {
  @Id()
  int id;


  @Property(type: PropertyType.dateNano)
  DateTime dataDeal;

  final prodottiDeals = ToMany<DealProduct>();

  Deal({this.id = 0, required this.dataDeal});

  double getTotaleImportoInvestito(){
    double importoInvestito = 0;

    prodottiDeals.forEach((prodottoDeal) {
      importoInvestito += prodottoDeal.importoInvestito;
    });

    return importoInvestito;
  }

  String getDataCreazione(){
    return DateFormat('dd/MM/yyyy').format(dataDeal);
  }

  /// Trova tutti gli ordini di un deal
  List<Orders> getOrdini() {
    List<int> idOrdini = [];
    List<Orders> ordini = [];

    for (DealProduct prodottoDeal in prodottiDeals) {
      for (OrderProduct productOrder in prodottoDeal.productsOrder) {
        if(!idOrdini.contains(productOrder.order.targetId)){
          if(productOrder.order.hasValue){
            ordini.add(productOrder.order.target!);
            idOrdini.add(productOrder.order.targetId);
          }
        }
      }
    }

    return ordini;
  }

  double getTotaleImportoRientrato(){
    double importoRientrato = 0;

    getOrdini().forEach((ordine) {
      importoRientrato += ordine.getTotaleRientrato();
    });
    return importoRientrato;

  }

  double getTotaleGuadagno() {
    double totale = 0;
    double totaleRientrato = getTotaleImportoRientrato();
    double totaleInvestito = getTotaleImportoInvestito();

    if(totaleRientrato > totaleInvestito){
      totale = totaleRientrato - totaleInvestito;
    }

    return totale;

  }


}