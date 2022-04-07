import 'package:equatable/equatable.dart';

import 'contact.dart';
import 'domain.dart';
import 'insurance.dart';
import 'order/promotion.dart';
import 'station.dart';
import 'user.dart';

// ignore: must_be_immutable
class Cart extends Equatable {
  final Station station;
  final Domain domain;
  DateTime startDate;
  final String validity;
  List<Contact> contacts;
  List<Contact> selectedContacts;
  List<Contact> selectedInsurances;
  final Insurance insurance;

  final List<Promotion> promotions;

  Cart({
    required this.station,
    required this.domain,
    required this.startDate,
    required this.validity,
    required this.contacts,
    required this.selectedContacts,
    required this.selectedInsurances,
    required this.insurance,
    required this.promotions,
  });

  @override
  List<Object?> get props =>
      [station, domain, startDate, selectedContacts, selectedInsurances];
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

  factory Cart.fromJsonFirstSimulation(
      {required Map<String, dynamic> json,
      required User user,
      required Station station,
      required Domain domain,
      required List<Contact> selectedContacts}) {
    DateTime? startDate = DateTime.tryParse(json['firstSkiDate']);
    var contacts = user.contacts;
    var selectedContactsTemp = selectedContacts;
    var orderItems = json['orderitems'] as List<dynamic>?;
    if (orderItems != null) {
      orderItems.forEach((orderItem) {
        String consumerCategoryName = '';
        try {
          consumerCategoryName = station.consumerCategories
              .where((elementConsumerCategories) =>
                  elementConsumerCategories.shortName ==
                  orderItem['initialConscat'])
              .first
              .label;
        } catch (e) {
          consumerCategoryName = orderItem['initialConscat'];
        }
        contacts
            .where((element) => element.index == orderItem['skierIndex'])
            .first
          ..price = orderItem['total'] ?? 0
          // ..price = orderItem['maxPublicPrice'] ?? 0
          ..consumerCategoryName = consumerCategoryName;
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
    return Cart(
        station: station,
        domain: domain,
        startDate: startDate!,
        contacts: contacts,
        validity: '1DAY',
        selectedContacts: selectedContactsTemp,
        selectedInsurances: [],
        insurance: insurance,
        promotions: promotions);
  }
  factory Cart.fromJsonFirstSimulationExtra({
    required Map<String, dynamic> json,
    required Cart cart,
  }) {
    var orderItems = json['orderitems'] as List<dynamic>?;
    var cartTemp = cart;
    if (orderItems != null) {
      orderItems.forEach((orderItem) {
        String consumerCategoryName = '';
        try {
          consumerCategoryName = cartTemp.station.consumerCategories
              .where((elementConsumerCategories) =>
                  elementConsumerCategories.shortName ==
                  orderItem['initialConscat'])
              .first
              .label;
        } catch (e) {
          consumerCategoryName = orderItem['initialConscat'];
        }
        cart.contacts
            .where((element) => element.index == orderItem['skierIndex'])
            .first
          ..price = orderItem['total'] ?? 0
          // ..price = orderItem['maxPublicPrice'] ?? 0
          ..consumerCategoryName = consumerCategoryName;
      });
    }
    return cartTemp;
  }
  factory Cart.fromJsonFirstSimulationWithPossiblePromo(
      {required Map<String, dynamic> json,
      required User user,
      required Station station,
      required Domain domain,
      required List<Contact> selectedContacts}) {
    DateTime? startDate = DateTime.tryParse(json['firstSkiDate']);
    var contacts = user.contacts;
    var selectedContactsTemp = selectedContacts;
    var orderItems = json['orderitems'] as List<dynamic>?;
    if (orderItems != null) {
      orderItems.forEach((orderItem) {
        String consumerCategoryName = '';
        try {
          consumerCategoryName = station.consumerCategories
              .where((elementConsumerCategories) =>
                  elementConsumerCategories.shortName ==
                  orderItem['initialConscat'])
              .first
              .label;
        } catch (e) {
          consumerCategoryName = orderItem['initialConscat'];
        }
        contacts
            .where((element) => element.index == orderItem['skierIndex'])
            .first
          ..price = orderItem['total'] ?? 0
          // ..price = orderItem['maxPublicPrice'] ?? 0
          ..consumerCategoryName = consumerCategoryName;
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
    return Cart(
        station: station,
        domain: domain,
        startDate: startDate!,
        contacts: contacts,
        validity: '1DAY',
        selectedContacts: selectedContactsTemp,
        selectedInsurances: [],
        insurance: insurance,
        promotions: promotions);
  }
}
