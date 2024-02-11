import 'package:deal/main.dart';
import 'package:deal/objectbox.g.dart';
import 'package:deal/objectbox/object-box-impl.dart';
import 'package:objectbox/objectbox.dart';
import '../model/customer.dart';
import '../model/debt.dart';
import '../model/order.dart';
class CustomerDao implements ObjectBoxImplement{

  @override
  Box<Customer> get box => objectbox.store.box<Customer>();

  Box<Orders> get ordersBox => objectbox.store.box<Orders>();

  Box<Debt> get debtBox => objectbox.store.box<Debt>();

  @override
  bool delete(int id) {
    return box.remove(id);
  }

  @override
  List<Customer> getAll() {
    return box.getAll();
  }

  @override
  Future<List<Customer>> getAllAsync() {
    return box.getAllAsync();
  }

  @override
  Stream<List<Customer>> getAllStream() {
    return box
        .query()
        .watch(triggerImmediately: true)
        .map((event) => event.find());
  }

  @override
  int put(object) {
    return box.put(object);
  }


  Customer? getCustomerByName(String nome) {
    Query<Customer> query = box.query(Customer_.name.equals(nome)).build();
    return query.findUnique();
  }

  List<Customer> customerConDebiti(){

    List<Debt> debitiAttivi = debtBox.query(Debt_.isAttivo.equals(true)).build().find();
    List<int> ids = [];
    List<Customer> indebitati = [];

    for(Debt debt in debitiAttivi){
      Customer customer = debt.order.target!.customer.target!;
      if(!ids.contains(customer.id)) {
        ids.add(customer.id);
        indebitati.add(customer);
        continue;
      }
    }


    return indebitati;

  }


}