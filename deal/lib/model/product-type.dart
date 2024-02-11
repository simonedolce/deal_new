import 'package:objectbox/objectbox.dart';

@Entity()
class ProductType {
  @Id()
  int id;

  String descrizione;

  ProductType({this.id = 0,required this.descrizione});
}