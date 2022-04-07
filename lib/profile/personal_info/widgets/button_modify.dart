import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';

class ButtonModify extends StatelessWidget {
  final Function()? onPressed;
  const ButtonModify({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
      child: Container(
        height: 48,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                ColorsApp.BackgroundBrandSecondary),
          ),
          onPressed: onPressed,
          child: Center(
            child: Text(
              'Modifier ma photo de profil',
              style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Color.fromRGBO(0, 104, 157, 1),
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}
