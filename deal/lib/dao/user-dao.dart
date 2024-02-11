import 'package:deal/main.dart';
import 'package:deal/model/user.dart';
import 'package:deal/objectbox/object-box-impl.dart';

import 'package:objectbox/objectbox.dart';

class UserDao implements ObjectBoxImplement {
  @override
  Box<User> get box => objectbox.store.box<User>();

  @override
  bool delete(int id) {
    return box.remove(id);
  }

  @override
  List<User> getAll() {
    return box.getAll();
  }

  @override
  Future<List<User>> getAllAsync() {
    return box.getAllAsync();
  }

  @override
  Stream<List<User>> getAllStream() {
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