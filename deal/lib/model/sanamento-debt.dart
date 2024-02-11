import 'package:objectbox/objectbox.dart';

import 'debt.dart';

@Entity()
class SanamentoDebt {
  @Id()
  int id;

  double? importoSanamento;

  DateTime? dataSanamento;

  final debt = ToOne<Debt>();

  SanamentoDebt({this.id = 0, this.importoSanamento, this.dataSanamento});
}