import 'package:objectbox/objectbox.dart';

import 'order.dart';

@Entity()
class Customer  {
  @Id()
  int id;

  DateTime? dataRegistrazione;

  String name;

  final ordini = ToMany<Orders>();

  Customer({this.id = 0, this.name = '', this.dataRegistrazione});


  double totaleDebitoDovuto(){
    double totale = 0;
    if(ordini.isNotEmpty) {
      for(Orders ordine in ordini){
        if(ordine.debito.hasValue){
          if(ordine.debito.target!.isAttivo){
            totale += ordine.debito.target!.totaleRimastoDaPagare();
          }
        }
      }
    }

    return totale;

  }
}
