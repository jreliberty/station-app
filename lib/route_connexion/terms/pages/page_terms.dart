import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/colors.dart';
import '../../login/pages/page_login.dart';
import '../widgets/dialog_cookies.dart';

class PageTerms extends StatefulWidget {
  PageTerms({Key? key}) : super(key: key);

  @override
  _PageTermsState createState() => _PageTermsState();
}

class _PageTermsState extends State<PageTerms> {
  var firebaseAnalytics = FirebaseAnalytics.instance;
  bool isOn = true;
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        children: [
          Container(
            height: 44,
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overScroll) {
                    overScroll.disallowIndicator();
                    return false;
                  },
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 46, left: 46, bottom: 12),
                        child: Text(
                          tr('connection.terms.title'),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                              height: 1.3,
                              fontSize: 16,
                              //color: Color(#687787),
                              color: ColorsApp.ContentPrimary,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        color: ColorsApp.ContentDivider,
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        tr('connection.terms.text1'),
                        textAlign: TextAlign.left,
                        style: GoogleFonts.roboto(
                            height: 1.4,
                            fontSize: 16,
                            //color: Color(#687787),
                            color: ColorsApp.ContentTertiary,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        '',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.roboto(
                            height: 1.4,
                            fontSize: 16,
                            //color: Color(#687787),
                            color: ColorsApp.ContentTertiary,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        tr('connection.terms.text2'),
                        textAlign: TextAlign.left,
                        style: GoogleFonts.roboto(
                            height: 1.4,
                            fontSize: 16,
                            //color: Color(#687787),
                            color: ColorsApp.ContentTertiary,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        '',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.roboto(
                            height: 1.4,
                            fontSize: 16,
                            //color: Color(#687787),
                            color: ColorsApp.ContentTertiary,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        tr('connection.terms.text3'),
                        textAlign: TextAlign.left,
                        style: GoogleFonts.roboto(
                            height: 1.4,
                            fontSize: 16,
                            //color: Color(#687787),
                            color: ColorsApp.ContentTertiary,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Container(
                        height: 56,
                        child: ElevatedButton(
                            onPressed: () async {
                              firebaseAnalytics
                                  .setAnalyticsCollectionEnabled(true);

                              var prefs = await SharedPreferences.getInstance();
                              await prefs.setString('cookies', 'true');
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          PageLogin()));
                            },
                            child: Text(
                              tr('connection.terms.buttons.button1.label'),
                              style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  //color: Color(#687787),
                                  color: ColorsApp.ContentPrimaryReversed,
                                  fontWeight: FontWeight.w700),
                            )),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: ColorsApp.BackgroundBrandSecondary),
                          onPressed: () async {
                            bool? isAccepted = await showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    DialogCookies());
                            if (isAccepted != null && isAccepted) {
                              firebaseAnalytics
                                  .setAnalyticsCollectionEnabled(true);
                              var prefs = await SharedPreferences.getInstance();
                              await prefs.setString('cookies', 'true');
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          PageLogin()));
                            }
                          },
                          child: Text(
                            tr('connection.terms.buttons.button2.label'),
                            style: GoogleFonts.roboto(
                                fontSize: 15,
                                color: ColorsApp.ContentAction,
                                fontWeight: FontWeight.w700),
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
                            elevation: 0,
                            primary: ColorsApp.BackgroundPrimary,
                          ),
                          onPressed: () async {
                            firebaseAnalytics
                                .setAnalyticsCollectionEnabled(false);
                            var prefs = await SharedPreferences.getInstance();
                            await prefs.setString('cookies', 'true');
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        PageLogin()));
                          },
                          child: Text(
                            tr('connection.terms.buttons.button3.label'),
                            style: GoogleFonts.roboto(
                                fontSize: 15,
                                color: ColorsApp.ContentAction,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
