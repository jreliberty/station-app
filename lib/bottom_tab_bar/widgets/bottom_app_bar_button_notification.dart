import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../blocs/notifications/notifications_bloc.dart';

class BottomAppBarButtonNotification extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final int index;
  final TabController controller;

  BottomAppBarButtonNotification(
      {Key? key,
      required this.icon,
      required this.label,
      required this.color,
      required this.index,
      required this.controller})
      : super(key: key);

  @override
  _BottomAppBarButtonNotificationState createState() =>
      _BottomAppBarButtonNotificationState();
}

class _BottomAppBarButtonNotificationState
    extends State<BottomAppBarButtonNotification> {
  bool hasUnreadNotifications = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        if (state is NotificationsLoadSuccess) {
          hasUnreadNotifications = false;
          if (state.notifications.isNotEmpty)
            state.notifications.forEach((element) {
              if (!(element.read)) hasUnreadNotifications = true;
              print(!(element.read));
            });
        }
        return Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Expanded(
                    child: IconButton(
                        icon: Icon(widget.icon, color: widget.color),
                        onPressed: () {
                          widget.controller.animateTo(widget.index);
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    widget.label,
                    style: GoogleFonts.roboto(
                        fontSize: 10,
                        //color: Color(#687787),
                        color: widget.color,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
            hasUnreadNotifications
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 10,),
                          Column(
                            children: [
                              Center(
                                  child: ClipOval(
                                child: Container(
                                    width: 10, height: 10, color: Colors.red),
                              )),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  )
                : Container(),
          ],
        );
      },
    );
  }
}
