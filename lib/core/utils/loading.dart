import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';

class Loading extends StatefulWidget {
  Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white.withOpacity(0.6),
        child: Center(
            child: Container(
                height: 60,
                width: 60,
                child: CircularProgressIndicator(
                  color: ColorsApp.BackgroundBrandPrimary,
                  strokeWidth: 7,
                ))));
  }
}

class LoadingPromo extends StatefulWidget {
  LoadingPromo({Key? key}) : super(key: key);

  @override
  _LoadingPromoState createState() => _LoadingPromoState();
}

class _LoadingPromoState extends State<LoadingPromo> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white.withOpacity(0.6),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                'Nous recalculons les prix !',
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
        )));
  }
}