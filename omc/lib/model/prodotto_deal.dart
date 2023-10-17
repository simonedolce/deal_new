import 'package:omc/model/prodotto.dart';


class ProdottoDeal {
  final int id;
  final Prodotto prodotto;
  final double quantitativoProdottoDeal;
  final double disponibilitaPersonale;
  final double disponibilitaMercato;
  final double quantitativoProdottoDealIniziale;
  final double disponibilitaMercatoIniziale;
  final double disponibilitaPersonaleIniziale;
  final double prezzoIngrosso;
  final double prezzoDettaglio;
  final double importoInvestito;
  final double importoRientrato;


  ProdottoDeal(
      this.id,
      this.prodotto,
      this.quantitativoProdottoDeal,
      this.disponibilitaPersonale,
      this.disponibilitaMercato,
      this.quantitativoProdottoDealIniziale,
      this.disponibilitaMercatoIniziale,
      this.disponibilitaPersonaleIniziale,
      this.prezzoIngrosso,
      this.prezzoDettaglio,
      this.importoInvestito,
      this.importoRientrato
      );

  factory ProdottoDeal.fromJson(Map<String, dynamic> json) {
    return ProdottoDeal(
      json['id'],
      Prodotto.fromJson(json['prodotto']),
      json['quantitativoProdottoDeal'],
      json['disponibilitaPersonale'],
      json['disponibilitaMercato'],
      json['quantitativoProdottoDealIniziale'],
      json['disponibilitaMercatoIniziale'],
      json['disponibilitaPersonaleIniziale'],
      json['prezzoIngrosso'],
      json['prezzoDettaglio'],
      json['importoInvestito'],
      json['importoRientrato'],
    );

  }
  Map<String, dynamic> toJson() => {
    'id': id,
    'prodotto': prodotto.toJson(),
    'quantitativoProdottoDeal':quantitativoProdottoDeal,
    'disponibilitaPersonale': disponibilitaPersonale,
    'disponibilitaMercato':disponibilitaMercato,
    'quantitativoProdottoDealIniziale':quantitativoProdottoDealIniziale,
    'disponibilitaMercatoIniziale':disponibilitaMercatoIniziale,
    'disponibilitaPersonaleIniziale':disponibilitaPersonaleIniziale,
    'prezzoIngrosso':prezzoIngrosso,
    'prezzoDettaglio': prezzoDettaglio,
    'importoInvestito': importoInvestito,
    'importoRientrato': importoRientrato,
  };

  bool isEsaurito(){
    return disponibilitaMercato <= 0;
  }
}