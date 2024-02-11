import 'package:deal/main.dart';
import 'package:deal/model/debt.dart';
import 'package:deal/objectbox/object-box-impl.dart';

import '../objectbox.g.dart';

class DebtDAO implements ObjectBoxImplement {
  @override
  Box<Debt> get box => objectbox.store.box<Debt>();

  @override
  bool delete(int id) {
    return box.remove(id);
  }

  @override
  List<Debt> getAll() {
    return box.getAll();
  }

  @override
  List<Debt> getAllAttivi() {
    return box.query(Debt_.isAttivo.equals(true)).build().find();
  }

  @override
  Future<List<Debt>> getAllAsync() {
    return box.getAllAsync();
  }

  @override
  Stream<List<Debt>> getAllStream() {
    return box
        .query()
        .watch(triggerImmediately: true)
        .map((event) => event.find());
  }

  @override
  int put(object) {
    return box.put(object);
  }

}