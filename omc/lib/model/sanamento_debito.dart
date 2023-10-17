
import 'debt.dart';

class SanamentoDebito {

  int? id;

  double importoSanamento;

  int dataSanamento;

  Debt? debito;

  SanamentoDebito(
      this.id,
      this.importoSanamento,
      this.dataSanamento,
      this.debito
  );

  factory SanamentoDebito.fromJson(Map<String, dynamic> json) {
    var debito = null;

    if(json['debito'] != null){
       debito = Debt.fromJson(json['debito']);
    }


    return SanamentoDebito(
        json['id'],
        json['importoSanamento'],
        json['dataSanamento'],
        debito
    );
  }

  Map<String, dynamic> toJson() => {
    'id':id,
    'importoSanamento': importoSanamento,
    'dataSanamento':dataSanamento,
    'debt': debito
  };

}