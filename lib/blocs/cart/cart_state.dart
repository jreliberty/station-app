part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoadInProgress extends CartState {}

class CartLoadSuccess extends CartState {
  final Cart cart;

  const CartLoadSuccess({required this.cart});
}

class CartLoadFailure extends CartState {
  final ViolationError violationError;

  const CartLoadFailure({required this.violationError});
}
