part of 'notifications_bloc.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoadInProgress extends NotificationsState {}

class NotificationsLoadSuccess extends NotificationsState {
  final List<PushNotification> notifications;

  NotificationsLoadSuccess({required this.notifications});
}

class NotificationsLoadFailure extends NotificationsState {}
