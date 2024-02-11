import '../objectbox.g.dart';

abstract class ObjectBoxImplement<T> {

  Box<T> get box;

  int put(T object);

  Stream<List<T>> getAllStream();

  List<T> getAll();

  Future<List<T>> getAllAsync();

  bool delete(int id);
}