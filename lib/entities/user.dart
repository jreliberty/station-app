import 'dart:math';

import 'package:equatable/equatable.dart';

import '../core/functions/functions.dart';
import 'adress.dart';
import 'contact.dart';

class User extends Equatable {
  final String id;
  final int elibertyId;
  final int payerId;
  final String contactId;
  final String firstName;
  final String lastName;
  final DateTime? birthDate;
  final String numPass;
  final String email;
  final String phoneNumber;
  final List<Address> adresses;
  final List<Contact> contacts;
  final String image;
  final String language;
  final String countryCode;

  User({
    required this.id,
    required this.contactId,
    required this.elibertyId,
    required this.payerId,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.numPass,
    required this.phoneNumber,
    required this.email,
    required this.adresses,
    required this.contacts,
    required this.image,
    required this.language,
    required this.countryCode,
  });

  @override
  List<Object?> get props => [
        id,
        contactId,
        elibertyId,
        payerId,
        firstName,
        lastName,
        birthDate,
        numPass,
        phoneNumber,
        email,
        adresses,
        contacts,
        image,
        language,
        countryCode,
      ];

  bool checkData() {
    return (this.firstName != '' &&
        this.lastName != '' &&
        this.phoneNumber != '' &&
        this.birthDate != null &&
        this.elibertyId != 0);
  }

  void addPass(Contact contact) {
    this.contacts.add(contact);
  }

  void deletePass(Contact contact) {
    this.contacts.remove(contact);
  }

  void modifyPass(Contact newContact, Contact lastContact) {
    this.contacts.remove(lastContact);
    this.contacts.add(newContact);
  }

  int getMaxIndexContact() {
    int index = 0;
    if (this.contacts.isNotEmpty)
      this.contacts.forEach((element) {
        index = max(index, element.index);
      });
    return index;
  }

  void addAdress(Address adress) {
    this.adresses.add(adress);
  }

  void deleteAdress(Address adress) {
    this.adresses.remove(adress);
  }

  void modifyAdress(Address newAdress, Address lastAdress) {
    this.adresses.remove(lastAdress);
    this.adresses.add(newAdress);
  }

  int getMaxIndexAdress() {
    int index = 0;
    if (this.adresses.isNotEmpty)
      this.adresses.forEach((element) {
        index = max(index, element.index);
      });
    return index;
  }

  factory User.fromJson(
      {required Map<String, dynamic> json,
      required Map<String, dynamic>? jsonContacts}) {
    var user = {};
    if (json['contact'] != null) user = json['contact'] as Map<String, dynamic>;
    List<Contact> contacts = [];
    int index = 1;
    if (jsonContacts != null) {
      var _contacts = jsonContacts['hydra:member'] as List<dynamic>?;
      if (_contacts != null)
        _contacts.forEach((_contact) {
          var birthdatecontact = _contact['birth_date'] != null
              ? _contact['birth_date'].toString() //.substring(0, 10)
              : '';
          String middleName = _contact['middle_name'] ?? '';
          if (!middleName.contains("deleted")) {
            contacts.add(Contact(
                index: index,
                firstName: _contact['first_name'] ?? '',
                middleName: _contact['middle_name'] ?? '',
                lastName: _contact['last_name'] ?? '',
                birthDate: birthdatecontact != ''
                    ? DateTime.tryParse(birthdatecontact)!
                        .add(Duration(hours: 2))
                    : DateTime.now(),
                numPass: _contact['pass_number'],
                age: getAge(
                  birthdatecontact != ''
                      ? DateTime.tryParse(birthdatecontact)!
                          .add(Duration(hours: 2))
                      : DateTime.now(),
                ),
                consumerCategoryName: null,
                isPrincipal: false,
                price: 0,
                elibertyId: _contact['eliberty_id'],
                id: _contact['id']));
            index++;
          }
        });
    }
    List<Address> adresses = [];
    var address = user['addresses'] as List<dynamic>?;
    index = 0;
    if (address != null)
      address.forEach((_adress) {
        adresses.add(Address(
            index: index,
            title: _adress['title'] ?? '',
            street: _adress['street'] ?? '',
            postalCode: _adress['postal_code'] ?? '',
            city: _adress['locality'] ?? '',
            country: _adress['title'] ?? '',
            isPrefered: _adress['favorite'] ?? false,
            id: _adress['id'] ?? ''));
        index++;
      });

    var id = json['id'] != null ? json['id'].toString() : '';
    var contactId = user['id'] != null ? user['id'].toString() : '';
    int elibertyId = user['eliberty_id'] != null ? user['eliberty_id'] : 0;
    int payerId = user['payer_id'] != null ? user['payer_id'] : 0;
    var firstname =
        user['first_name'] != null ? user['first_name'].toString() : '';
    var middlename =
        user['first_name'] != null ? user['middle_name'].toString() : '';
    var lastname =
        user['last_name'] != null ? user['last_name'].toString() : '';
    var birthdate = user['birth_date'] != null
        ? user['birth_date'].toString() //.substring(0, 10)
        : '';
    var keycardNumber =
        user['pass_number'] != null ? user['pass_number'].toString() : '';

    var email = json['email'] != null ? json['email'].toString() : '';
    var language = user['language'] != null ? user['language'].toString() : '';
    var phoneNumber = user['mobile_phone_number'] != null
        ? user['mobile_phone_number'].toString()
        : '';
    var countryCode =
        user['country_code'] != null ? user['country_code'].toString() : '';
    var image = json['image'] != null ? json['image'].toString() : '';
    if (keycardNumber != '')
      contacts.add(Contact(
          index: 0,
          firstName: firstname,
          middleName: middlename,
          lastName: lastname,
          birthDate: birthdate != ''
              ? DateTime.tryParse(birthdate)!.add(Duration(hours: 2))
              : DateTime.now(),
          numPass: keycardNumber,
          age: getAge(DateTime.tryParse(birthdate)!.add(Duration(hours: 2))),
          consumerCategoryName: null,
          isPrincipal: true,
          price: 0,
          elibertyId: elibertyId,
          id: contactId));

    return User(
      id: id,
      firstName: firstname,
      lastName: lastname,
      birthDate: birthdate != ''
          ? DateTime.tryParse(birthdate)!.add(Duration(hours: 2))
          : null,
      numPass: keycardNumber,
      phoneNumber: phoneNumber,
      email: email,
      adresses: adresses,
      contacts: contacts,
      image: image,
      countryCode: countryCode,
      language: language,
      contactId: contactId,
      elibertyId: elibertyId,
      payerId: payerId,
    );
  }
}
