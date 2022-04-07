import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';

class LoadingScaffoldMaps extends StatefulWidget {
  LoadingScaffoldMaps({Key? key}) : super(key: key);

  @override
  _LoadingScaffoldMapsState createState() => _LoadingScaffoldMapsState();
}

class _LoadingScaffoldMapsState extends State<LoadingScaffoldMaps> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'Les nouveaux prix sont en cours de chargement !',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
                fontSize: 18,
                //color: Color(#687787),
                color: ColorsApp.BackgroundBrandPrimary,
                fontWeight: FontWeight.w700),
          ),
        ),
        Container(
            height: 60,
            width: 60,
            child: CircularProgressIndicator(
              color: ColorsApp.BackgroundBrandPrimary,
              strokeWidth: 7,
            )),
      ],
    ));
  }
}
