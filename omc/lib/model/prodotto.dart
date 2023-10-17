import 'tipo_prodotto.dart';

class Prodotto {

  final int id;

  final String nomeProdotto;

  final TipoProdotto tipoProdotto;

  Prodotto(
      this.id,
      this.nomeProdotto,
      this.tipoProdotto
      );

  factory Prodotto.fromJson(Map<String, dynamic> json) {
    return Prodotto(
        json['id'],
        json['nomeProdotto'],
        TipoProdotto.fromJson(json['tipoProdotto'])
    );
  }

  Map<String, dynamic> toJson() => {
    'id':id,
    'nomeProdotto': nomeProdotto,
    'tipoProdotto': tipoProdotto.toJson()
  };
}