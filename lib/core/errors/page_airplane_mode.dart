import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_settings/open_settings.dart';

import '../../constants/colors.dart';

class PageAirplaneMode extends StatefulWidget {
  PageAirplaneMode({Key? key}) : super(key: key);

  @override
  _PageAirplaneModeState createState() => _PageAirplaneModeState();
}

class _PageAirplaneModeState extends State<PageAirplaneMode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          FlutterRemix.wifi_off_line,
          size: 60,
          color: ColorsApp.ContentInactive,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 32, bottom: 0),
          child: Text(
            'Vous êtes en mode avion',
            style: GoogleFonts.roboto(
                fontSize: 18,
                //color: Color(#687787),
                color: ColorsApp.ContentPrimary,
                fontWeight: FontWeight.w400),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          'Désactivez le et réessayez',
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
            primary: ColorsApp.ContentActive,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
          onPressed: () async {
            OpenSettings.openAirplaneModeSetting();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Désactiver',
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
