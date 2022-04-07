part of 'fast_cart_bloc.dart';

abstract class FastCartEvent extends Equatable {
  const FastCartEvent();

  @override
  List<Object> get props => [];
}

class GetFirstSimulationFastCartEvent extends FastCartEvent {
  final User user;
  final Station station;
  final Domain domain;
  final String startDate;
  final List<Contact> selectedContacts;

  GetFirstSimulationFastCartEvent(
      {required this.station,
      required this.domain,
      required this.user,
      required this.startDate,
      required this.selectedContacts});
}

class GetFirstSimulationFastCartEventWithPossiblePromoEvent extends FastCartEvent {
  final User user;
  final Station station;
  final Domain domain;
  final String startDate;
  final List<Contact> selectedContacts;

  GetFirstSimulationFastCartEventWithPossiblePromoEvent({
    required this.station,
    required this.domain,
    required this.user,
    required this.startDate,
    required this.selectedContacts,
  });
}

class SetFastCartEvent extends FastCartEvent {
  final Cart cart;

  SetFastCartEvent({required this.cart});
}

class EmptyFastCartEvent extends FastCartEvent {
  
}

