import 'package:equatable/equatable.dart';

import 'contact.dart';
import 'domain.dart';
import 'insurance.dart';
import 'order/promotion.dart';
import 'station.dart';
import 'user.dart';

// ignore: must_be_immutable
class FastCart extends Equatable {
  Station station;
  Domain domain;
  DateTime startDate;
  final String validity;
  List<Contact> contacts;
  List<Contact> selectedContacts;
  List<Contact> selectedInsurances;
  final Insurance insurance;
  final List<Promotion> promotions;

  FastCart(
      {required this.station,
      required this.domain,
      required this.startDate,
      required this.validity,
      required this.contacts,
      required this.selectedContacts,
      required this.selectedInsurances,
      required this.insurance,
      required this.promotions});

  @override
  List<Object?> get props => [selectedContacts, selectedInsurances];

  void changeSkiDate(DateTime date) {
    this.startDate = date;
  }

  void changeDomainAndStation(Station station, Domain domain) {
    this.station = station;
    this.domain = domain;
  }

  void setSelectedContacts(List<Contact> selectedContacts) {
    this.selectedContacts = selectedContacts;
  }

  void addContact(Contact contact) {
    this.selectedContacts.add(contact);
  }

  void removeContact(Contact contact) {
    this
        .selectedContacts
        .removeWhere((element) => element.numPass == contact.numPass);
  }

  void addContactInsurance(Contact contact) {
    this.selectedInsurances.add(contact);
  }

  void removeContactInsurance(Contact contact) {
    this
        .selectedInsurances
        .removeWhere((element) => element.numPass == contact.numPass);
  }

  void clearContactsInsurance() {
    this.selectedInsurances = [];
  }

  factory FastCart.fromJsonFirstSimulation(
      {required Map<String, dynamic> json,
      required User user,
      required Station station,
      required Domain domain}) {
    var startDate =
        DateTime.tryParse(json['firstSkiDate'])!.add(Duration(hours: 2));
    var contacts = user.contacts;

    var orderItems = json['orderitems'] as List<dynamic>?;
    if (orderItems != null) {
      orderItems.forEach((orderItem) {
        contacts
            .where((element) => element.index == orderItem['skierIndex'])
            .first
          ..price = orderItem['total']
          ..consumerCategoryName = orderItem['initialConscat'];
      });
    }

    List<Promotion> promotions = [];
    var promotionItems = json["promotions"] as List<dynamic>;
    if (promotionItems.isNotEmpty) {
      promotionItems.forEach((element) {
        promotions.add(Promotion.fromJson(json: element));
      });
    }
    var availableOptions = json['availableoptions'] as List<dynamic>?;
    var insurance = Insurance.fromJson(json: availableOptions![0]);
    return FastCart(
        station: station,
        domain: domain,
        startDate: startDate,
        contacts: contacts,
        validity: '1DAY',
        selectedContacts: [],
        selectedInsurances: [],
        insurance: insurance,
        promotions: promotions);
  }
}
