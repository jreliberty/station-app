part of 'orders_history_bloc.dart';

abstract class OrdersHistoryEvent extends Equatable {
  const OrdersHistoryEvent();

  @override
  List<Object> get props => [];
}

class InitOrdersHistoryEvent extends OrdersHistoryEvent {}

class UpdateOrdersHistoryEvent extends OrdersHistoryEvent {
  final OrderHistory orderHistory;
  final Order order;

  UpdateOrdersHistoryEvent({required this.orderHistory, required this.order});
}
