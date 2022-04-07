import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../blocs/consumer/consumer_bloc.dart';
import '../../../blocs/newsletter/newsletter_bloc.dart';
import '../../../blocs/notifications/notifications_bloc.dart';
import '../../../bottom_tab_bar/pages/page_bottom_tab_bar.dart';
import '../../../constants/colors.dart';
import '../../../entities/push_notification.dart';

class PageNewsletterUnsubscribedInit extends StatefulWidget {
  final int index;
  PageNewsletterUnsubscribedInit({Key? key, required this.index})
      : super(key: key);

  @override
  _PageNewsletterUnsubscribedInitState createState() =>
      _PageNewsletterUnsubscribedInitState();
}

class _PageNewsletterUnsubscribedInitState
    extends State<PageNewsletterUnsubscribedInit> {
  bool hasPass = false;
  @override
  void initState() {
    super.initState();
    if (BlocProvider.of<ConsumerBloc>(context).state is ConsumerLoadSuccess) {
      hasPass =
          (BlocProvider.of<ConsumerBloc>(context).state as ConsumerLoadSuccess)
                  .user
                  .numPass !=
              '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                Image.asset(
                  'assets/newsletter/newsletter.png',
                ),
                SizedBox(
                  height: 26,
                ),
                Text(
                  'Abonne-toi à notre newsletter 🤓',
                  style: GoogleFonts.roboto(
                      height: 1.11,
                      fontSize: 34,
                      color: ColorsApp.ContentPrimary,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      FlutterRemix.check_fill,
                      color: Color.fromRGBO(35, 169, 66, 1),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Les meilleurs offres en avant première',
                      style: GoogleFonts.roboto(
                          height: 1.65,
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      overflow: TextOverflow.clip,
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      FlutterRemix.check_fill,
                      color: Color.fromRGBO(35, 169, 66, 1),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Nouvelles stations disponibles',
                      style: GoogleFonts.roboto(
                          height: 1.65,
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      overflow: TextOverflow.clip,
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      FlutterRemix.check_fill,
                      color: Color.fromRGBO(35, 169, 66, 1),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Nos conseils ski...',
                      style: GoogleFonts.roboto(
                          height: 1.65,
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      overflow: TextOverflow.clip,
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(0, 125, 188, 1)),
                    onPressed: () {
                      BlocProvider.of<NewsletterBloc>(context)
                          .add(SubscribeNewsletterEvent());
                      List<PushNotification> notifications = [];
                      if (BlocProvider.of<NotificationsBloc>(context).state
                          is NotificationsLoadSuccess) {
                        notifications =
                            (BlocProvider.of<NotificationsBloc>(context).state
                                    as NotificationsLoadSuccess)
                                .notifications;
                      }
                      PushNotification pushNotification;
                      if (hasPass)
                        pushNotification = PushNotification(
                            read: false,
                            index: 0,
                            title: 'Bienvenue !',
                            body:
                                'Bienvenue au club, profite bien de l\'avoir de 15€ par carte !',
                            imageUrl:
                                'https://static.decathlonpass.com/images/Logo-RVB.png',
                            sentTime: DateTime.now());
                      else
                        pushNotification = PushNotification(
                            read: false,
                            index: 0,
                            title: 'Bienvenue au club !',
                            body:
                                'Pour acheter tes forfaits sur notre app, il faut que tu complètes ton profil en ajoutant un Pass.',
                            imageUrl:
                                'https://static.decathlonpass.com/images/Logo-RVB.png',
                            sentTime: DateTime.now());
                      BlocProvider.of<NotificationsBloc>(context).add(
                          AddNotificationEvent(
                              pushNotification: pushNotification,
                              notifications: notifications));
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => PageBottomTabBar(
                                initialIndex: widget.index,
                              )));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          FlutterRemix.mail_line,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 14),
                          child: Text(
                            'Je m’abonne',
                            style: GoogleFonts.roboto(
                                height: 1,
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(247, 248, 249, 1)),
                    onPressed: () {
                      List<PushNotification> notifications = [];
                      if (BlocProvider.of<NotificationsBloc>(context).state
                          is NotificationsLoadSuccess) {
                        notifications =
                            (BlocProvider.of<NotificationsBloc>(context).state
                                    as NotificationsLoadSuccess)
                                .notifications;
                      }
                      PushNotification pushNotification;
                      if (hasPass)
                        pushNotification = PushNotification(
                            read: false,
                            index: 0,
                            title: 'Bienvenue !',
                            body:
                                'Bienvenue au club, profite bien de l\'avoir de 15€ par carte !',
                            imageUrl:
                                'https://static.decathlonpass.com/images/Logo-RVB.png',
                            sentTime: DateTime.now());
                      else
                        pushNotification = PushNotification(
                            read: false,
                            index: 0,
                            title: 'Bienvenue au club !',
                            body:
                                'Pour acheter tes forfaits sur notre app, il faut que tu complètes ton profil en ajoutant un Pass.',
                            imageUrl:
                                'https://static.decathlonpass.com/images/Logo-RVB.png',
                            sentTime: DateTime.now());
                      BlocProvider.of<NotificationsBloc>(context).add(
                          AddNotificationEvent(
                              pushNotification: pushNotification,
                              notifications: notifications));
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => PageBottomTabBar(
                                initialIndex: widget.index,
                              )));
                    },
                    child: Center(
                      child: Text(
                        'Pas pour l\'instant',
                        style: GoogleFonts.roboto(
                            height: 1,
                            fontSize: 16,
                            color: Color.fromRGBO(0, 104, 157, 1),
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
