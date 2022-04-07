import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String id;
  final String title;
  final String street;
  final String postalCode;
  final String city;
  final String country;
  final bool isPrefered;
  final int index;

  Address({
    required this.id,
    required this.index,
    required this.title,
    required this.street,
    required this.postalCode,
    required this.city,
    required this.country,
    required this.isPrefered,
  });

  @override
  List<Object> get props => [street, postalCode, city, title, index];
}
