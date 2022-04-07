part of 'consumer_bloc.dart';

abstract class ConsumerEvent extends Equatable {
  const ConsumerEvent();

  @override
  List<Object> get props => [];
}

class InitConsumerEvent extends ConsumerEvent {}

class ListenConsumerEvent extends ConsumerEvent {
  final String userId;

  ListenConsumerEvent(this.userId);
}

class CreateContactEvent extends ConsumerEvent {
  final String body;
  final String bodyPhone;
  final String userId;

  CreateContactEvent({
    required this.body,
    required this.bodyPhone,
    required this.userId,
  });
}

class UpdateContactPersonalInfoEvent extends ConsumerEvent {
  final String body;
  final String contactId;

  UpdateContactPersonalInfoEvent({
    required this.body,
    required this.contactId,
  });
}

class CreateContactAdressEvent extends ConsumerEvent {
  final String body;

  CreateContactAdressEvent({
    required this.body,
  });
}

class UpdateContactAdressEvent extends ConsumerEvent {
  final String body;
  final String adressId;

  UpdateContactAdressEvent({
    required this.adressId,
    required this.body,
  });
}

class DeleteContactAdressEvent extends ConsumerEvent {
  final String adressId;

  DeleteContactAdressEvent({
    required this.adressId,
  });
}

class AssignPassEvent extends ConsumerEvent {
  final String contactId;
  final String passId;

  AssignPassEvent({required this.passId, required this.contactId});
}

class CreateSubcontactEvent extends ConsumerEvent {
  final String body;
  final String passId;

  CreateSubcontactEvent({required this.passId, required this.body});
}

class UpdateSubcontactEvent extends ConsumerEvent {
  final String body;
  final String contactId;
  final String passId;

  UpdateSubcontactEvent({
    required this.body,
    required this.contactId,
    required this.passId,
  });
}
