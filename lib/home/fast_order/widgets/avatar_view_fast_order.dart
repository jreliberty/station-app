import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/colors.dart';

class AvatarViewFastOrder extends StatefulWidget {
  final String initials;
  const AvatarViewFastOrder({
    Key? key,
    required this.initials,
  }) : super(key: key);

  @override
  _AvatarViewFastOrderState createState() => _AvatarViewFastOrderState();
}

class _AvatarViewFastOrderState extends State<AvatarViewFastOrder> {
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        height: 64,
        width: 64,
        color: Color.fromRGBO(0, 125, 188, 1),
        child: Padding(
          padding: EdgeInsets.all(4.6),
          child: ClipOval(
              child: Center(
            child: Text(
              widget.initials,
              style: GoogleFonts.roboto(
                  fontSize: 24,
                  color: ColorsApp.ContentPrimaryReversed,
                  fontWeight: FontWeight.w700),
            ),
          )),
        ),
      ),
    );
  }
}
