part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class AddNotificationEvent extends NotificationsEvent {
  final List<PushNotification> notifications;
  final PushNotification pushNotification;

  AddNotificationEvent(
      {required this.pushNotification, required this.notifications});
}

class UpdateNotificationEvent extends NotificationsEvent {
  final List<PushNotification> notifications;
  final PushNotification pushNotification;

  UpdateNotificationEvent(
      {required this.pushNotification, required this.notifications});
}

class InitNotificationsEvent extends NotificationsEvent {}
