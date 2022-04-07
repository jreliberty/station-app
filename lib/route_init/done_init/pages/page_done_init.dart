import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../blocs/consumer/consumer_bloc.dart';
import '../../../blocs/notifications/notifications_bloc.dart';
import '../../../bottom_tab_bar/pages/page_bottom_tab_bar.dart';
import '../../../constants/colors.dart';
import '../../../core/utils/loading.dart';
import '../../../entities/push_notification.dart';
import '../../../entities/user.dart';

class PageDoneInit extends StatefulWidget {
  PageDoneInit({Key? key}) : super(key: key);

  @override
  _PageDoneInitState createState() => _PageDoneInitState();
}

late User user;
bool hasPass = false;

class _PageDoneInitState extends State<PageDoneInit> {
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
    return BlocBuilder<ConsumerBloc, ConsumerState>(
      builder: (context, state) {
        if (state is ConsumerLoadSuccess) user = state.user;
        return Scaffold(
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 125, 188, 1),
                  image: DecorationImage(
                    image: AssetImage("assets/congrats.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        tr('configuration.congrats.title',
                            args: [user.firstName.toUpperCase()]),
                        style: GoogleFonts.robotoCondensed(
                            height: 1,
                            fontSize: 42,
                            //color: Color(#687787),
                            fontStyle: FontStyle.italic,
                            color: ColorsApp.ContentPrimaryReversed,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        tr('configuration.congrats.subtitle'),
                        style: GoogleFonts.roboto(
                            height: 1.5,
                            fontSize: 16,
                            //color: Color(#687787),
                            color: ColorsApp.ContentPrimaryReversed,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: ColorsApp.BackgroundAccent),
                          onPressed: () {
                            List<PushNotification> notifications = [];
                            if (BlocProvider.of<NotificationsBloc>(context)
                                .state is NotificationsLoadSuccess) {
                              notifications =
                                  (BlocProvider.of<NotificationsBloc>(context)
                                          .state as NotificationsLoadSuccess)
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
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        PageBottomTabBar(
                                          initialIndex: 1,
                                        )));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                FlutterRemix.navigation_line,
                                color: ColorsApp.ContentAccent,
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    tr('configuration.congrats.buttons.button1.label'),
                                    style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        color: ColorsApp.ContentAccent,
                                        fontWeight: FontWeight.w700),
                                  )),
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
                            primary: ColorsApp.BackgroundPrimary,
                          ),
                          onPressed: () {
                            List<PushNotification> notifications = [];
                            if (BlocProvider.of<NotificationsBloc>(context)
                                .state is NotificationsLoadSuccess) {
                              notifications =
                                  (BlocProvider.of<NotificationsBloc>(context)
                                          .state as NotificationsLoadSuccess)
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
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        PageBottomTabBar(
                                          initialIndex: 0,
                                        )));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                FlutterRemix.home_2_line,
                                color: ColorsApp.ContentPrimary,
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    tr('configuration.congrats.buttons.button2.label'),
                                    style: GoogleFonts.roboto(
                                        fontSize: 15,
                                        color: ColorsApp.ContentPrimary,
                                        fontWeight: FontWeight.w700),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                    ],
                  ),
                ),
              ),
              (state is ConsumerLoadFailure) ? Loading() : Container(),
            ],
          ),
        );
      },
    );
  }
}
