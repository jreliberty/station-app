import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../bottom_tab_bar/pages/page_bottom_tab_bar.dart';
import '../../../constants/colors.dart';

class PagePaymentError extends StatefulWidget {
  PagePaymentError({Key? key}) : super(key: key);

  @override
  _PagePaymentErrorState createState() => _PagePaymentErrorState();
}

class _PagePaymentErrorState extends State<PagePaymentError> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/payment/fail.png"),
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.8), BlendMode.dstATop),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      'OUPS ! ',
                      style: GoogleFonts.robotoCondensed(
                          height: 1,
                          fontSize: 42,
                          //color: Color(#687787),
                          fontStyle: FontStyle.italic,
                          color: ColorsApp.ContentPrimaryReversed,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '😬️',
                      style: GoogleFonts.robotoCondensed(
                          height: 1,
                          fontSize: 42,
                          //color: Color(#687787),
                          color: ColorsApp.ContentPrimaryReversed,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Votre paiement n’a pas pu aboutir. Cela peut être dû à votre connexion internet. Pas de panique, vous n’avez pas été débité !',
                  style: GoogleFonts.roboto(
                      height: 1.5,
                      fontSize: 16,
                      //color: Color(#687787),
                      color: ColorsApp.ContentPrimaryReversed,
                      fontWeight: FontWeight.w400),
                ),
                // SizedBox(
                //   height: 16,
                // ),
                // Container(
                //   width: double.infinity,
                //   height: 56,
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //         primary: Color.fromRGBO(0, 125, 188, 1)),
                //     onPressed: () {
                //       Navigator.of(context).pushReplacement(MaterialPageRoute(
                //           builder: (BuildContext context) => PageBottomTabBar(
                //                 initialIndex: 1,
                //               )));
                //     },
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         Icon(
                //           Icons.refresh,
                //           color: ColorsApp.ContentPrimaryReversed,
                //         ),
                //         Padding(
                //             padding: const EdgeInsets.only(left: 10),
                //             child: Text(
                //               'Réessayer',
                //               style: GoogleFonts.roboto(
                //                   fontSize: 16,
                //                   color: ColorsApp.ContentPrimaryReversed,
                //                   fontWeight: FontWeight.w700),
                //             )),
                //       ],
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: ColorsApp.ContentPrimaryReversed),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => PageBottomTabBar(
                                initialIndex: 0,
                              )));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          FlutterRemix.home_2_fill,
                          color: Color.fromRGBO(0, 16, 21, 1),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Aller à l’accueil',
                              style: GoogleFonts.roboto(
                                  fontSize: 15,
                                  color: Color.fromRGBO(0, 16, 21, 1),
                                  fontWeight: FontWeight.w700),
                            )),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
