part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class CreatePaymentEvent extends PaymentEvent {
  final CardPayment cardPayment;

  CreatePaymentEvent({required this.cardPayment});
}
