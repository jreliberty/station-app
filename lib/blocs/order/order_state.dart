part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoadInProgress extends OrderState {}

class OrderLoadSuccess extends OrderState {
  final Order order;

  OrderLoadSuccess({required this.order});
}

class OrderLoadFailure extends OrderState {
  final ViolationError violationError;

  const OrderLoadFailure({required this.violationError});

  @override
  List<Object> get props => [violationError];
}
