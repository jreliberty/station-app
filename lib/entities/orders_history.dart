import 'package:equatable/equatable.dart';

import 'order/order.dart';

class OrderHistory extends Equatable {
  final List<Order> orders;
  final List<Order> listOrdersToCome;
  final List<Order> listOrdersPassed;

  OrderHistory({
    required this.orders,
    required this.listOrdersToCome,
    required this.listOrdersPassed,
  });

  factory OrderHistory.fromJson({required Map<String, dynamic> json}) {
    final orders = <Order>[];
    final listOrdersToCome = <Order>[];
    final listOrdersPassed = <Order>[];
    if (json['data'] != Null) {
      for (var orderJson in json['data'] as List<dynamic>) {
        var order = Order.fromJson(json: orderJson);
        orders.add(order);
        if (order.skiDate.isAfter(DateTime.now()) ||
            (order.skiDate.day == DateTime.now().day &&
                order.skiDate.month == DateTime.now().month)) {
          listOrdersToCome.add(order);
        } else
          listOrdersPassed.add(order);
      }
      orders.sort((a, b) => b.skiDate.compareTo(a.skiDate));
      listOrdersPassed.sort((a, b) => b.skiDate.compareTo(a.skiDate));
      listOrdersToCome.sort((a, b) => b.skiDate.compareTo(a.skiDate));
      print(OrderHistory(
          orders: orders,
          listOrdersToCome: listOrdersToCome,
          listOrdersPassed: listOrdersPassed));
      return OrderHistory(
          orders: orders,
          listOrdersToCome: listOrdersToCome,
          listOrdersPassed: listOrdersPassed);
    } else
      return OrderHistory(
          orders: [], listOrdersToCome: [], listOrdersPassed: []);
  }

  @override
  List<Object?> get props => [orders, listOrdersToCome, listOrdersPassed];
}
