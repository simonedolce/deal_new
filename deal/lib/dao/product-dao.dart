import 'package:deal/main.dart';
import 'package:deal/model/product.dart';
import 'package:deal/objectbox/object-box-impl.dart';

import '../objectbox.g.dart';

class ProductDao implements ObjectBoxImplement {
  @override
  Box<Product> get box => objectbox.store.box<Product>();

  @override
  bool delete(int id) {
    return box.remove(id);
  }

  @override
  List<Product> getAll() {
    return box.getAll();
  }

  @override
  Future<List<Product>> getAllAsync() {
    return box.getAllAsync();
  }

  @override
  Stream<List<Product>> getAllStream() {
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