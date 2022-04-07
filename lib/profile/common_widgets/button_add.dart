import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';

class ButtonAdd extends StatelessWidget {
  final String label;
  final Function()? onPressed;
  const ButtonAdd({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 32),
      child: Container(
        height: 48,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                ColorsApp.BackgroundBrandSecondary),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Color.fromRGBO(0, 104, 157, 1),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    label,
                    style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Color.fromRGBO(0, 104, 157, 1),
                        fontWeight: FontWeight.w700),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
