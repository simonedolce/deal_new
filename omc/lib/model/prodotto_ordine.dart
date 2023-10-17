
import 'package:omc/model/prodotto_deal.dart';

class ProdottoOrdine {

  final int id;
  double quantitativoEffettivo;
  double quantitativoPrevisto;
  ProdottoDeal prodottoDeal;

  ProdottoOrdine(
      this.id,
      this.quantitativoEffettivo,
      this.quantitativoPrevisto,
      this.prodottoDeal
  );

  factory ProdottoOrdine.fromJson(Map<String, dynamic> json) {
    return ProdottoOrdine(
      json['id'],
      json['quantitativoEffettivo'],
      json['quantitativoPrevisto'],
      ProdottoDeal.fromJson(json['prodottoDeal'])
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'quantitativoEffettivo': quantitativoEffettivo,
    'quantitativoPrevisto': quantitativoPrevisto,
    'prodottoDeal': prodottoDeal.toJson(),
  };

  //setQuantitativoPrevisto(double quantitativoPrevisto){
  //  this.quantitativoPrevisto = quantitativoPrevisto;
  //}


}