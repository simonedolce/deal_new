import 'package:deal/model/deal-product.dart';
import 'package:objectbox/objectbox.dart';

import 'order.dart';

@Entity()
class OrderProduct {

  @Id()
  int id;

  final productDeals = ToOne<DealProduct>();

  final order = ToOne<Orders>();

  double quantitativoEffetivo;

  double quantitativoPrevisto;

  double prezzoAlDettaglio;

  OrderProduct({
    this.id = 0,
    this.quantitativoEffetivo = 0,
    this.quantitativoPrevisto = 0,
    this.prezzoAlDettaglio = 0
  });

  double getPrezzoTotale(){
    return quantitativoPrevisto * prezzoAlDettaglio;
  }

}