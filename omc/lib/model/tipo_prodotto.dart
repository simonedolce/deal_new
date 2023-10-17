class TipoProdotto {
  final int id;
  final String descrizione;

  TipoProdotto(this.id,this.descrizione);

  factory TipoProdotto.fromJson(Map<String, dynamic> json) {
    return TipoProdotto(json['id'], json['descrizione']);
  }
  Map<String, dynamic> toJson() => {'id':id,'descrizione': descrizione};
}