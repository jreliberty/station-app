import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';
import '../../entities/push_notification.dart';

class NotificationTileOverlay extends StatefulWidget {
  final PushNotification notification;
  NotificationTileOverlay({Key? key, required this.notification})
      : super(key: key);

  @override
  _NotificationTileOverlayState createState() =>
      _NotificationTileOverlayState();
}

class _NotificationTileOverlayState extends State<NotificationTileOverlay> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: (widget.notification.read)
              ? Colors.white
              : ColorsApp.BackgroundBrandSecondary,
          border: Border(bottom: BorderSide(color: ColorsApp.ContentDivider))),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 40,
                width: 40,
                child: ClipOval(
                    child: Image.network(
                  widget.notification.imageUrl ?? '',
                  fit: BoxFit.cover,
                )),
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
