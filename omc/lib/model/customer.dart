import 'ordine.dart';

class Customer {
  int id;
  String nome;
  List<Ordine>? ordini;

  Customer(
    this.id,
    this.nome,
    this.ordini
  );

  factory Customer.fromJson(Map<String, dynamic> json) {
    var ordiniList = null;
    if(json['ordini'] != null){
      var ordiniListJson = json['ordini'] as List<dynamic>;
      ordiniList = ordiniListJson
          .map((ordineJson) => Ordine.fromJson(ordineJson)).toList();
    }


    return Customer(
        json['id'],
        json['nome'],
        ordiniList
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'ordini': ordini?.map((ordine) => ordine.toJson()).toList(),
  };

}