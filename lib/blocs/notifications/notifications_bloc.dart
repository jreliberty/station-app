import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../constants/colors.dart';
import '../../entities/push_notification.dart';
import '../../notifications/widgets/notification_tile_overlay.dart';
import '../../repository/api_repository.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final ApiRepository apiRepository;
  NotificationsBloc({required this.apiRepository})
      : super(NotificationsInitial());

  @override
  Stream<NotificationsState> mapEventToState(NotificationsEvent event) async* {
    if (event is AddNotificationEvent) {
      yield NotificationsLoadInProgress();
      var notifications = event.notifications;
      print('notif : ' + event.notifications.toString());
      Future.delayed(Duration(seconds: 2), () {
        showSimpleNotification(
          NotificationTileOverlay(notification: event.pushNotification),
          background: ColorsApp.BackgroundBrandSecondary,
          duration: Duration(seconds: 4),
        );
      });
      print('object');
      notifications.removeWhere(
          (element) => element.index == event.pushNotification.index);
      notifications.add(event.pushNotification);
      await apiRepository.updateCacheNotifications(
          notifications: notifications);
      yield NotificationsLoadSuccess(notifications: notifications);
    } else if (event is UpdateNotificationEvent) {
      yield NotificationsLoadInProgress();
      var notifications = event.notifications;
      notifications.removeWhere(
          (element) => element.index == event.pushNotification.index);
      notifications.add(event.pushNotification);
      await apiRepository.updateCacheNotifications(
          notifications: notifications);
      yield NotificationsLoadSuccess(notifications: notifications);
    } else if (event is InitNotificationsEvent) {
      yield NotificationsLoadInProgress();
      var notifications = await apiRepository.initNotificationsFromCache();
      print(notifications);
      yield NotificationsLoadSuccess(notifications: notifications);
    }
  }
}
