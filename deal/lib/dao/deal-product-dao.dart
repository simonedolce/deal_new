import 'package:deal/main.dart';
import 'package:deal/model/deal-product.dart';
import 'package:deal/objectbox/object-box-impl.dart';

import '../objectbox.g.dart';

class DealProductDao implements ObjectBoxImplement {
  @override
  Box<DealProduct> get box => objectbox.store.box<DealProduct>();

  @override
  bool delete(int id) {
    return box.remove(id);
  }

  @override
  List<DealProduct> getAll() {
    return box.getAll();
  }

  @override
  Future<List<DealProduct>> getAllAsync() {
    return box.getAllAsync();
  }

  @override
  Stream<List<DealProduct>> getAllStream() {
    return box
        .query()
        .watch(triggerImmediately: true)
        .map((event) => event.find());
  }

  @override
  int put(object) {
    return box.put(object);
  }

  List<DealProduct> getDisponibile() {
    QueryBuilder<DealProduct> builder = box.query(DealProduct_.disponibilitaMercato.greaterThan(0));
    return builder.build().find();
  }
}