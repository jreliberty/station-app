import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';

class ButtonSave extends StatelessWidget {
  const ButtonSave({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 32),
      child: Container(
        height: 56,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Color.fromRGBO(0, 125, 188, 1)),
          ),
          onPressed: () {},
          child: Text(
            'Enregistrer mes modifications',
            style: GoogleFonts.roboto(
                fontSize: 16,
                color: ColorsApp.ContentPrimaryReversed,
                fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
