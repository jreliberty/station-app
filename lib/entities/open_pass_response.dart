import 'package:equatable/equatable.dart';

class OpenPassResponse extends Equatable {
  final bool active;
  final bool blocked;
  final String cardNumber;
  final int id;
  final int? contactId;

  OpenPassResponse({
    required this.active,
    required this.blocked,
    required this.cardNumber,
    required this.id,
    required this.contactId,
  });

  factory OpenPassResponse.fromJson(Map<String, dynamic> jsonData) {
    return OpenPassResponse(
        active: jsonData['active'],
        blocked: jsonData['blocked'],
        cardNumber: jsonData['cardNumber'],
        id: jsonData['id'],
        contactId: jsonData['contact']);
  }

  @override
  List<Object?> get props => [
        active,
        blocked,
        cardNumber,
        id,
        contactId,
      ];
}
