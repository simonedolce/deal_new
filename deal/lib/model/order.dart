import 'package:deal/model/debt.dart';
import 'package:deal/model/order-product.dart';
import 'package:deal/model/sanamento-debt.dart';
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

import 'customer.dart';
@Entity()
class Orders {
  @Id()
  int id;

  @Property(type: PropertyType.date)
  DateTime dataOrdine;

  double totale;

  double totalePagato;

  final customer = ToOne<Customer>();

  @Backlink('order')
  final prodottiOrdine = ToMany<OrderProduct>();

  final debito = ToOne<Debt>();

  Orders({this.id = 0, required this.dataOrdine, this.totale = 0, this.totalePagato = 0});

  double getTotale(){
    double totale = 0;

    prodottiOrdine.forEach((element) {
      totale += element.quantitativoPrevisto * element.prezzoAlDettaglio;
    });

    return totale;
  }

  double getQuantitaTotale(){
    double totale = 0;
    prodottiOrdine.forEach((element) {
      totale += element.quantitativoPrevisto;
    });
    return totale;
  }

  double getTotaleRientrato()  {
    double importoRientrato = getTotale();

    importoRientrato = getTotale();

    if(debito.hasValue){
      Debt obj = debito.target!;
      importoRientrato -= obj.importoDebito;
      for (SanamentoDebt sanamento in obj.sanamenti) {
        importoRientrato += sanamento.importoSanamento!;
      }
    }

    return importoRientrato;
  }

  String getDataCreazione(){
    return DateFormat('dd/MM/yyyy').format(dataOrdine);
  }



  bool hasDebt(){
    bool hasDebt = false;

    if(debito.target != null){
      Debt obj = debito.target!;
      double importoDebito = obj.importoDebito;
      double counter = 0;

      for (SanamentoDebt sanamento in obj.sanamenti) {
        counter += sanamento.importoSanamento!;
      }

      hasDebt = counter < importoDebito;

    }

    return hasDebt;
  }

}