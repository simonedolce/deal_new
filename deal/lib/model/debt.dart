import 'package:deal/model/sanamento-debt.dart';
import 'package:objectbox/objectbox.dart';

import 'order.dart';

@Entity()
class Debt {

  @Id()
  int id;

  double importoDebito;

  bool isAttivo;

  final order = ToOne<Orders>();

  final sanamenti = ToMany<SanamentoDebt>();

  Debt({
    this.id = 0,
    required this.importoDebito,
    required this.isAttivo
  });

  bool isSanato(){
    return totaleRimastoDaPagare() == 0;
  }

  double totaleRimastoDaPagare(){
    double totaleRimasto = importoDebito;
    sanamenti.forEach(
            (sanamento) => totaleRimasto -= sanamento.importoSanamento!
    );
    return totaleRimasto;
  }


}