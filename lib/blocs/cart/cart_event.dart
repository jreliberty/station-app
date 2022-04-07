part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class GetFirstSimulationEvent extends CartEvent {
  final User user;
  final Station station;
  final Domain domain;
  final String startDate;
  final Validity selectedValidity;
  final List<Contact> selectedContacts;

  GetFirstSimulationEvent({
    required this.station,
    required this.domain,
    required this.user,
    required this.startDate,
    required this.selectedValidity,
    required this.selectedContacts,
  });
}

class GetFirstSimulationEventWithPossiblePromoEvent extends CartEvent {
  final User user;
  final Station station;
  final Domain domain;
  final String startDate;
  final Validity selectedValidity;
  final List<Contact> selectedContacts;

  GetFirstSimulationEventWithPossiblePromoEvent({
    required this.station,
    required this.domain,
    required this.user,
    required this.startDate,
    required this.selectedContacts,
    required this.selectedValidity,
  });
}

class SetCartEvent extends CartEvent {
  final Cart cart;

  SetCartEvent({required this.cart});
}
