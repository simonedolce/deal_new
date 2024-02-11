import 'package:deal/main.dart';
import 'package:deal/model/order.dart';
import 'package:deal/objectbox/object-box-impl.dart';
import 'package:flutter/material.dart';

import '../model/customer.dart';
import '../objectbox.g.dart';

class OrderDao implements ObjectBoxImplement {

  @override
  Box<Orders> get box => objectbox.store.box<Orders>();

  @override
  bool delete(int id) {
    return box.remove(id);
  }

  @override
  List<Orders> getAll() {
    return box.getAll();
  }

  @override
  Future<List<Orders>> getAllAsync() {
    return box.getAllAsync();
  }

  @override
  Stream<List<Orders>> getAllStream() {
    return box
        .query()
        .watch(triggerImmediately: true)
        .map((event) => event.find());
  }

  @override
  int put(object) {
    return box.put(object);
  }


  List<Orders> getOrdiniConDebiti(){
    List<Orders> list = [];
    QueryBuilder<Orders> builder = box.query();
    builder.link(Orders_.debito, Debt_.id.notNull());

    Query<Orders> query = builder.build();

    list = query.find();
    query.close();

    return list;
  }
  List<Orders> getAllFilter(Customer? customer , DateTimeRange? period, bool withDebito){
    List<Orders> filtered = [];

    QueryBuilder<Orders> queryBuilder = box.query();

    if(period != null){
      queryBuilder = box.query(Orders_.dataOrdine.between(period.start.millisecondsSinceEpoch, period.end.millisecondsSinceEpoch));
    }

    if(customer != null) {
      queryBuilder.link(Orders_.customer, Customer_.name.equals(customer.name));
    }

    if(withDebito){
      queryBuilder.link(Orders_.debito, Debt_.id.notNull());
      queryBuilder.link(Orders_.debito, Debt_.isAttivo.equals(true));
    }

    Query<Orders> query = queryBuilder.build();
    filtered = query.find();
    query.close();

    return filtered;
  }

  Stream<List<Orders>> getAllStreamFilter(Customer? customer) {
    QueryBuilder<Orders> queryBuilder = box.query();

    if(customer != null) {
      queryBuilder.link(Orders_.customer, Customer_.name.equals(customer.name));
    }

    return queryBuilder
        .watch(triggerImmediately: true)
        .map((event) => event.find());
  }
}