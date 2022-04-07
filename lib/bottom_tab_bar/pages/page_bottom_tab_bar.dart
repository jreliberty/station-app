import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:upgrader/upgrader.dart';

import '../../blocs/consumer/consumer_bloc.dart';
import '../../blocs/network/network_bloc.dart';
import '../../blocs/notifications/notifications_bloc.dart';
import '../../constants/colors.dart';
import '../../core/errors/page_airplane_mode.dart';
import '../../core/functions/functions.dart';
import '../../entities/push_notification.dart';
import '../../home/pages/page_home.dart';
import '../../notifications/pages/page_notifications.dart';
import '../../profile/home/pages/page_profile.dart';
import '../../route_order/map/pages/page_google_maps.dart';
import '../widgets/bottom_app_bar_button.dart';
import '../widgets/bottom_app_bar_button_notification.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class PageBottomTabBar extends StatefulWidget {
  final int initialIndex;
  PageBottomTabBar({Key? key, required this.initialIndex}) : super(key: key);

  @override
  _PageBottomTabBarState createState() => _PageBottomTabBarState();
}

class _PageBottomTabBarState extends State<PageBottomTabBar>
    with TickerProviderStateMixin {
  Future<bool> _onWillPop() async {
    return false;
  }

  late TabController _controller;
  late final FirebaseMessaging _messaging;

  void registerNotification() async {
    await Firebase.initializeApp();

    _messaging = FirebaseMessaging.instance;
    var token = await FirebaseMessaging.instance.getToken();
    print('token :  ' + token!);
    if (BlocProvider.of<ConsumerBloc>(context).state is ConsumerLoadSuccess) {
      var body = {
        "firebase_token": token,
        "language": "fr",
        "country_code": "FR",
        "gender": "male"
      };
      BlocProvider.of<ConsumerBloc>(context).add(UpdateContactPersonalInfoEvent(
        body: jsonEncode(body),
        contactId: (BlocProvider.of<ConsumerBloc>(context).state
                as ConsumerLoadSuccess)
            .user
            .contactId,
      ));
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print(message.data);
        print(
            'Message1 title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}, image: ${message.data["image"]}');

        // Parse the message received
        List<PushNotification> notifications = [];
        if (BlocProvider.of<NotificationsBloc>(context).state
            is NotificationsLoadSuccess)
          notifications = (BlocProvider.of<NotificationsBloc>(context).state
                  as NotificationsLoadSuccess)
              .notifications;

        int index = getMaxIndexNotifications(notifications);

        PushNotification pushNotification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          dataTitle: message.data['title'] ?? "",
          dataBody: message.data['body'] ?? "",
          imageUrl: message.data['image'] ?? "",
          sentTime: message.sentTime,
          index: index + 1,
          read: false,
        );

        BlocProvider.of<NotificationsBloc>(context).add(AddNotificationEvent(
            pushNotification: pushNotification, notifications: notifications));
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      List<PushNotification> notifications = [];
      if (BlocProvider.of<NotificationsBloc>(context).state
          is NotificationsLoadSuccess)
        notifications = (BlocProvider.of<NotificationsBloc>(context).state
                as NotificationsLoadSuccess)
            .notifications;

      int index = getMaxIndexNotifications(notifications);

      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
        dataTitle: initialMessage.data['title'] ?? "",
        dataBody: initialMessage.data['body'] ?? "",
        imageUrl: initialMessage.data['image'] ?? "",
        sentTime: initialMessage.sentTime,
        index: index + 1,
        read: false,
      );
      BlocProvider.of<NotificationsBloc>(context).add(AddNotificationEvent(
          pushNotification: notification, notifications: notifications));
    }
  }

  bool isInitiated = false;
  @override
  void initState() {
    if (!isInitiated) {
      init();
      isInitiated = true;
    }
    super.initState();
    //length: 5, vsync: this, initialIndex: widget.initialIndex);
  }

  init() {
    registerNotification();
    checkForInitialMessage();

    // For handling notification when the app is in background
    // but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      List<PushNotification> notifications = [];
      if (BlocProvider.of<NotificationsBloc>(context).state
          is NotificationsLoadSuccess)
        notifications = (BlocProvider.of<NotificationsBloc>(context).state
                as NotificationsLoadSuccess)
            .notifications;

      int index = getMaxIndexNotifications(notifications);

      print(message.data);
      print(
          'Message1 title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}, image: ${message.contentAvailable}');

      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'] ?? "",
        dataBody: message.data['body'] ?? "",
        imageUrl: message.data['image'] ?? "",
        sentTime: message.sentTime,
        index: index + 1,
        read: false,
      );
      BlocProvider.of<NotificationsBloc>(context).add(AddNotificationEvent(
          pushNotification: notification, notifications: notifications));
    });
    _controller = TabController(
        length: 4, vsync: this, initialIndex: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    _controller.addListener(() {
      setState(() {});
    });
    return WillPopScope(
      onWillPop: _onWillPop,
      child: BlocBuilder<NetworkBloc, NetworkState>(
        builder: (context, state) {
          if (state is NetworkSuccess) print('On est connectés');
          if (state is NetworkFailure) {
            print('On est pas connectés !');
            if (state.isAirplaneModeOn) return PageAirplaneMode();
          }

          return Scaffold(
            bottomNavigationBar: BottomAppBar(
                child: Container(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6.0, top: 6),
                child: TabBar(
                  indicatorColor: Colors.white,
                  controller: _controller,
                  tabs: <Widget>[
                    Tab(
                        child: _controller.index == 0
                            ? BottomAppBarButton(
                                icon: FlutterRemix.home_2_fill,
                                label: 'Accueil',
                                color: ColorsApp.ContentActive,
                                index: 0,
                                controller: _controller,
                              )
                            : BottomAppBarButton(
                                icon: FlutterRemix.home_2_line,
                                label: 'Accueil',
                                color: ColorsApp.ContentInactive,
                                index: 0,
                                controller: _controller,
                              )),
                    Tab(
                        iconMargin: EdgeInsets.all(0),
                        child: _controller.index == 1
                            ? BottomAppBarButton(
                                icon: FlutterRemix.navigation_fill,
                                label: 'Explorer',
                                color: ColorsApp.ContentActive,
                                index: 1,
                                controller: _controller,
                              )
                            : BottomAppBarButton(
                                icon: FlutterRemix.navigation_line,
                                label: 'Explorer',
                                color: ColorsApp.ContentInactive,
                                index: 1,
                                controller: _controller,
                              )),
                    Tab(
                        child: _controller.index == 2
                            ? BottomAppBarButtonNotification(
                                icon: FlutterRemix.notification_fill,
                                label: 'Notifications',
                                color: ColorsApp.ContentActive,
                                index: 2,
                                controller: _controller,
                              )
                            : BottomAppBarButtonNotification(
                                icon: FlutterRemix.notification_line,
                                label: 'Notifications',
                                color: ColorsApp.ContentInactive,
                                index: 2,
                                controller: _controller,
                              )),
                    Tab(
                        child: _controller.index == 3
                            ? BottomAppBarButton(
                                icon: FlutterRemix.user_fill,
                                label: 'Profil',
                                color: ColorsApp.ContentActive,
                                index: 3,
                                controller: _controller,
                              )
                            : BottomAppBarButton(
                                icon: FlutterRemix.user_line,
                                label: 'Profil',
                                color: ColorsApp.ContentInactive,
                                index: 3,
                                controller: _controller,
                              )),
                    /*Tab(
                        child: _controller.index == 4
                            ? BottomAppBarButton(
                                icon: FlutterRemix.shopping_cart_line,_fill,
                                label: 'Panier',
                                color: ColorsApp.ContentActive,
                                index: 4,
                                controller: _controller,
                              )
                            : BottomAppBarButton(
                                icon: FlutterRemix.shopping_cart_line,,
                                label: 'Panier',
                                color: ColorsApp.ContentInactive,
                                index: 4,
                                controller: _controller,
                              )),*/
                  ],
                ),
              ),
            )),
            body: UpgradeAlert(
              showIgnore: false,
              showLater: false,
              canDismissDialog: false,
              showReleaseNotes: false,
              countryCode: 'fr',
              durationToAlertAgain: Duration(),
              child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _controller,
                  children: <Widget>[
                    PageHome(parentController: _controller),
                    PageGoogleMaps(),
                    PageNotifications(),
                    PageProfile(),
                    //PageBasket(),
                  ]),
            ),
          );
        },
      ),
    );
  }
}
