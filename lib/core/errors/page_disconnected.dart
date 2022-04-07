import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';

class PageDisconnected extends StatefulWidget {
  final Function() function;
  PageDisconnected({Key? key, required this.function}) : super(key: key);

  @override
  _PageDisconnectedState createState() => _PageDisconnectedState();
}

class _PageDisconnectedState extends State<PageDisconnected> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          FlutterRemix.error_warning_line,
          size: 80,
          color: Color.fromRGBO(137, 150, 162, 1),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 32, bottom: 0),
          child: Text(
            'Impossible de charger cette page.',
            style: GoogleFonts.roboto(
                fontSize: 18,
                color: ColorsApp.ContentPrimary,
                fontWeight: FontWeight.w400),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          'Vous n\'êtes pas connecté à internet.',
          style: GoogleFonts.roboto(
              letterSpacing: -0.24,
              fontSize: 15,
              color: ColorsApp.ContentInactive,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 16,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: ColorsApp.ActivePrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
          onPressed: widget.function,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Réessayer',
              style: GoogleFonts.roboto(
                  height: 1,
                  fontSize: 14,
                  color: ColorsApp.ContentPrimaryReversed,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    )));
  }
}
