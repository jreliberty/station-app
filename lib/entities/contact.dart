import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Contact extends Equatable {
  final String id;
  final int elibertyId;
  final String firstName;
  final String middleName;
  final String lastName;
  final DateTime birthDate;
  final String numPass;
  final int age;
  final int index;
  final bool isPrincipal;
  int price;
  String? consumerCategoryName;

  Contact(
      {required this.price,
      required this.index,
      required this.id,
      required this.elibertyId,
      required this.firstName,
      required this.middleName,
      required this.lastName,
      required this.birthDate,
      required this.numPass,
      required this.age,
      this.consumerCategoryName,
      required this.isPrincipal});

  @override
  List<Object?> get props => [
        id,
        elibertyId,
        firstName,
        middleName,
        lastName,
        birthDate,
        numPass,
        age,
        consumerCategoryName,
        index,
        price
      ];

  // void setConsumerCategory(List<ConsumerCategory> consumerCategories) {
  //   consumerCategories.forEach((element) {
  //     if (element.ageMin <= age && age <= element.ageMax)
  //       consumerCategoryName = element;
  //   });
  // }
}
