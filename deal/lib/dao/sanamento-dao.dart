import 'package:deal/main.dart';
import 'package:deal/model/sanamento-debt.dart';
import 'package:deal/objectbox/object-box-impl.dart';
import 'package:objectbox/src/native/box.dart';

class SanamentoDao implements ObjectBoxImplement {
  @override
  Box<SanamentoDebt> get box => objectbox.store.box<SanamentoDebt>();

  @override
  bool delete(int id) {
    return box.remove(id);
  }

  @override
  List<SanamentoDebt> getAll() {
    return box.getAll();
  }

  @override
  Future<List<SanamentoDebt>> getAllAsync() {
    return box.getAllAsync();
  }

  @override
  Stream<List<SanamentoDebt>> getAllStream() {
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