part of 'fast_cart_bloc.dart';

abstract class FastCartState extends Equatable {
  const FastCartState();

  @override
  List<Object> get props => [];
}

class FastCartInitial extends FastCartState {}

class FastCartLoadInProgress extends FastCartState {}

class FastCartLoadSuccess extends FastCartState {
  final Cart cart;

  const FastCartLoadSuccess({required this.cart});
}

class FastCartLoadFailure extends FastCartState {
  final ViolationError violationError;

  const FastCartLoadFailure({required this.violationError});
}
