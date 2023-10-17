import 'package:omc/model/ordine.dart';
import 'package:omc/model/sanamento_debito.dart';

class Debt {
  int id;
  Ordine? ordine;
  double importoDebito;
  bool isAttivo;

  List<SanamentoDebito>? sanamenti;

  Debt(
    this.id,
    this.ordine,
    this.importoDebito,
    this.sanamenti,
    this.isAttivo
  );

  factory Debt.fromJson(Map<String, dynamic> json) {
    Ordine? ordine;
    var sanamentiListJson = json['sanamenti'] as List<dynamic>;
    var sanamentiList = sanamentiListJson
        .map((sanamentoJson) => SanamentoDebito.fromJson(sanamentoJson)).toList();

    if(json['ordine'] != null){
      ordine = Ordine.fromJson(json['ordine']);
    }

    return Debt(
        json['id'],
        ordine,
        json['importoDebito'],
        sanamentiList,
        json['isAttivo']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'ordine': ordine,
    'importoDebito': importoDebito,
    'sanamenti':sanamenti?.map((sanamento) => sanamento.toJson()).toList(),
    'isAttivo':isAttivo
  };

}