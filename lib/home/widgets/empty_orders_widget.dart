import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';

class EmptyOrderWidget extends StatefulWidget {
  final TabController controller;
  EmptyOrderWidget({Key? key, required this.controller}) : super(key: key);

  @override
  _EmptyOrderWidgetState createState() => _EmptyOrderWidgetState();
}

class _EmptyOrderWidgetState extends State<EmptyOrderWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 22, left: 24, right: 24),
            child: Text(
              '''Ton forfait journée
en moins d’une minute''',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                  height: 1.17,
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 115),
          child: Container(
            width: 215,
            height: 48,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: ColorsApp.ContentActive,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
                onPressed: () async {
                  widget.controller.animateTo(1);
                },
                child: Text(
                  'Recharger ma carte',
                  style: GoogleFonts.poppins(
                      letterSpacing: 0.27,
                      height: 1,
                      fontSize: 16,
                      color: ColorsApp.ContentPrimaryReversed,
                      fontWeight: FontWeight.w700),
                )),
          ),
        ),
        SizedBox(
          height: 24,
        )
      ],
    );
  }
}
