part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class SaveSimulationToOrder extends OrderEvent {
  final Cart cart;

  SaveSimulationToOrder({required this.cart});
}
