import 'package:deal/model/product-type.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Product {

  @Id()
  int id;

  String nomeProdotto;

  final productType = ToOne<ProductType>();

  Product({this.id = 0,required this.nomeProdotto});
}