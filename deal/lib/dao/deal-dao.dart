import 'package:deal/main.dart';
import 'package:deal/model/deal.dart';
import 'package:deal/objectbox/object-box-impl.dart';

import 'package:objectbox/objectbox.dart';

class DealDao implements ObjectBoxImplement {

  @override
  Box<Deal> get box => objectbox.store.box<Deal>();

  @override
  bool delete(int id) {
    return box.remove(id);
  }

  @override
  List<Deal> getAll() {
    return box.getAll();
  }

  @override
  Future<List<Deal>> getAllAsync() {
    return box.getAllAsync();
  }

  @override
  Stream<List<Deal>> getAllStream() {
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