part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoadInProgress extends PaymentState {}

class PaymentLoadSuccess extends PaymentState {
  final PaymentResponse paymentResponse;

  PaymentLoadSuccess({required this.paymentResponse});
}

class PaymentLoadFailure extends PaymentState {
  final ViolationError violationError;

  const PaymentLoadFailure({required this.violationError});

  @override
  List<Object> get props => [violationError];
}
