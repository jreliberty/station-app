part of 'orders_history_bloc.dart';

abstract class OrdersHistoryState extends Equatable {
  const OrdersHistoryState();

  @override
  List<Object> get props => [];
}

class OrdersHistoryInitial extends OrdersHistoryState {}

class OrdersHistoryLoadInProgress extends OrdersHistoryState {}

class OrdersHistoryLoadSuccess extends OrdersHistoryState {
  final OrderHistory orderHistory;

  OrdersHistoryLoadSuccess({required this.orderHistory});
}

class OrdersHistoryLoadFailure extends OrdersHistoryState {
  final ViolationError violationError;

  const OrdersHistoryLoadFailure({required this.violationError});

  @override
  List<Object> get props => [violationError];
}
