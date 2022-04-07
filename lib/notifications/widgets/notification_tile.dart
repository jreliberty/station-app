import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';

import '../../blocs/notifications/notifications_bloc.dart';
import '../../constants/colors.dart';
import '../../entities/push_notification.dart';

class NotificationTile extends StatefulWidget {
  final List<PushNotification> notifications;
  final PushNotification notification;
  NotificationTile(
      {Key? key, required this.notification, required this.notifications})
      : super(key: key);

  @override
  _NotificationTileState createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var notification = widget.notification;
        notification.read = true;
        BlocProvider.of<NotificationsBloc>(context).add(UpdateNotificationEvent(
            pushNotification: notification,
            notifications: widget.notifications));
      },
      child: Container(
        decoration: BoxDecoration(
            color: (widget.notification.read)
                ? Colors.white
                : ColorsApp.BackgroundBrandSecondary,
            border:
                Border(bottom: BorderSide(color: ColorsApp.ContentDivider))),
        width: MediaQuery.of(context).size.width,
        height: 152,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 40,
                  width: 40,
                  child: (widget.notification.imageUrl != null &&
                          widget.notification.imageUrl != '')
                      ? ClipOval(
                          child: Image.network(
                          widget.notification.imageUrl ?? '',
                          fit: BoxFit.cover,
                        ))
                      : Container(),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.notification.title ?? '',
                      style: GoogleFonts.roboto(
                          height: 1.5,
                          fontSize: 16,
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      widget.notification.body ?? '',
                      style: GoogleFonts.roboto(
                          letterSpacing: -0.32,
                          height: 1.5,
                          fontSize: 16,
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontWeight: FontWeight.w400),
                    ),
                    Spacer(),
                    Text(
                      Jiffy(widget.notification.sentTime).fromNow().toString(),
                      style: GoogleFonts.roboto(
                          letterSpacing: -0.08,
                          height: 1.43,
                          fontSize: 14,
                          color: ColorsApp.ContentTertiary,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
