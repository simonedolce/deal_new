import 'package:omc/model/prodotto_ordine.dart';

import 'customer.dart';
import 'debt.dart';

class Ordine {
  int id;
  List<ProdottoOrdine> prodottiOrdine;
  int dataOrdine;
  double totale;
  double totalePagato;
  Customer? customer;
  Debt? debito;

  Ordine(
    this.id,
      this.prodottiOrdine,
      this.totale,
      this.totalePagato,
      this.dataOrdine,
      this.customer,
      this.debito
  );

  factory Ordine.fromJson(Map<String, dynamic> json) {

    var prodottiOrdineData = json['prodottiOrdine'] as List<dynamic>;
    var prodottiOrdineList = prodottiOrdineData
        .map((prodottoOrdineJson) => ProdottoOrdine.fromJson(prodottoOrdineJson)).toList();
    var customer = null;
    var debito = null;

    if(json['customer'] != null){
      customer = Customer.fromJson(json['customer']);
    }

    if(json['debito'] != null){
      debito = Debt.fromJson(json['debito']);
    }

    return Ordine(
        json['id'],
        prodottiOrdineList,
        json['totale'],
        json['totalePagato'],
        json['dataOrdine'],
        customer,
        debito
    );
  }

  Map<String, dynamic> toJson() => {
    'id':id,
    'prodottiOrdine': prodottiOrdine.map((prodottoOrdine) => prodottoOrdine.toJson()).toList(),
    'totale':totale,
    'totalePagato':totalePagato,
    'dataOrdine':dataOrdine,
    'customer': customer?.toJson(),
    'debito': debito?.toJson()
  };

}
