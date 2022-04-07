import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../blocs/notifications/notifications_bloc.dart';
import '../../constants/colors.dart';
import '../../entities/push_notification.dart';
import '../widgets/notification_tile.dart';

class PageNotifications extends StatefulWidget {
  PageNotifications({Key? key}) : super(key: key);

  @override
  _PageNotificationsState createState() => _PageNotificationsState();
}

class _PageNotificationsState extends State<PageNotifications> {
  List<PushNotification> listNotifications = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        if (state is NotificationsLoadSuccess) {
          listNotifications = state.notifications;
          print(listNotifications.length);
          if (listNotifications.isNotEmpty)
            listNotifications.sort((a, b) => b.index.compareTo(a.index));
          return Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 52, left: 24, bottom: 16),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Notifications',
                      style: GoogleFonts.roboto(
                          height: 1.2,
                          fontSize: 20,
                          color: ColorsApp.ContentPrimary,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                (listNotifications.isNotEmpty)
                    ? Expanded(
                        child: NotificationListener<
                            OverscrollIndicatorNotification>(
                          onNotification:
                              (OverscrollIndicatorNotification overScroll) {
                            overScroll.disallowIndicator();
                            return false;
                          },
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.all(0),
                            scrollDirection: Axis.vertical,
                            itemCount: listNotifications.length,
                            itemBuilder: (context, index) {
                              return NotificationTile(
                                notification: listNotifications[index],
                                notifications: listNotifications,
                              );
                            },
                          ),
                        ),
                      )
                    : Expanded(
                        child: Center(
                          child: Text(
                            'Aucune notification à afficher !',
                            style: GoogleFonts.roboto(
                                height: 1.43,
                                fontSize: 14,
                                color: ColorsApp.ContentTertiary,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),

                // Expanded(
                //   child: Center(
                //       child: EmptyWidget(
                //     packageImage: PackageImage.Image_4,
                //     titleTextStyle: TextStyle(
                //       fontSize: 20,
                //       color: Color(0xff9da9c7),
                //       fontWeight: FontWeight.w500,
                //     ),
                //     title: 'Aucune notification',
                //     subTitle: 'Pour l\'instant !',
                //   )),
                // ),
              ],
            ),
          );
        } else
          return Container();
      },
    );
  }
}
