import 'package:deal/model/order-product.dart';
import 'package:deal/model/product.dart';
import 'package:objectbox/objectbox.dart';

import 'deal.dart';

@Entity()
class DealProduct {
  @Id()
  int id;

  double quantitativoProdottoDeal;

  double disponibilitaPersonale;

  double disponibilitaMercato;

  double quantitativoProdottoDealIniziale;

  double disponibilitaMercatoIniziale;

  double disponibilitaPersonaleIniziale;

  double prezzoIngrosso;

  double prezzoDettaglio;

  double importoInvestito;

  double importoRientrato;

  final product = ToOne<Product>();

  final deal = ToOne<Deal>();

  @Backlink("productDeals")
  final productsOrder = ToMany<OrderProduct>() ;

  DealProduct({
    this.id = 0,
    this.quantitativoProdottoDeal = 0,
    this.disponibilitaPersonale = 0,
    this.disponibilitaMercato = 0,
    this.quantitativoProdottoDealIniziale = 0,
    this.disponibilitaMercatoIniziale = 0,
    this.disponibilitaPersonaleIniziale = 0,
    this.prezzoIngrosso = 0,
    this.prezzoDettaglio = 0,
    this.importoInvestito = 0,
    this.importoRientrato = 0
  });
}