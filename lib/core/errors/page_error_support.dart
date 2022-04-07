import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../bottom_tab_bar/pages/page_bottom_tab_bar.dart';
import '../../constants/colors.dart';
import '../../profile/contact/pages/page_contact.dart';

class PageErrorSupport extends StatefulWidget {
  PageErrorSupport({Key? key}) : super(key: key);

  @override
  _PageErrorSupportState createState() => _PageErrorSupportState();
}

class _PageErrorSupportState extends State<PageErrorSupport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          //color: Colors.black.withOpacity(0.5),
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
                'Il y a eu un problème. Notre équipe travaille dur pour le résoudre !',
                style: GoogleFonts.roboto(
                    height: 1.5,
                    fontSize: 16,
                    //color: Color(#687787),
                    color: ColorsApp.ContentPrimaryReversed,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 32,
              ),
              Container(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(0, 125, 188, 1)),
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
                        FlutterRemix.home_2_line,
                        color: ColorsApp.ContentPrimaryReversed,
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Retour à la page d\'accueil',
                            style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: ColorsApp.ContentPrimaryReversed,
                                fontWeight: FontWeight.w700),
                          )),
                    ],
                  ),
                ),
              ),
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => PageContact()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FlutterRemix.mail_line,
                        color: Color.fromRGBO(0, 16, 21, 1),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Écrivez-nous',
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
    );
  }
}
