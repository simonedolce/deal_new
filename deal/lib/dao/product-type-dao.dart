import 'package:deal/main.dart';
import 'package:deal/objectbox/object-box-impl.dart';

import '../model/product-type.dart';
import '../objectbox.g.dart';

class ProductTypeDao implements ObjectBoxImplement {
  @override
  Box<ProductType> get box => objectbox.store.box<ProductType>();

  @override
  bool delete(int id) {
    return box.remove(id);
  }

  @override
  List<ProductType> getAll() {
    return box.getAll();
  }

  @override
  Future<List<ProductType>> getAllAsync() {
    return box.getAllAsync();
  }

  @override
  Stream<List<ProductType>> getAllStream() {
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