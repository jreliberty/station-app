import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/colors.dart';

class PageContact extends StatefulWidget {
  PageContact({Key? key}) : super(key: key);

  @override
  _PageContactState createState() => _PageContactState();
}

class _PageContactState extends State<PageContact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowIndicator();
            return false;
          },
          child: ListView(children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(FlutterRemix.arrow_left_line),
                  color: ColorsApp.ContentPrimary,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    'Contact',
                    style: GoogleFonts.roboto(
                        height: 1.2,
                        fontSize: 20,
                        color: ColorsApp.ContentPrimary,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            Image.asset(
              'assets/contact.png',
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              'Vous souhaitez nous contacter ? 👋',
              style: GoogleFonts.roboto(
                  height: 1.11,
                  fontSize: 34,
                  color: ColorsApp.ContentPrimary,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Vous pouvez contacter l’un de nos conseillers par mail ou par téléphone. Nous serons ravis de pouvoir répondre à vos questions !',
              style: GoogleFonts.roboto(
                  height: 1.33,
                  fontSize: 15,
                  letterSpacing: -0.24,
                  color: ColorsApp.ContentTertiary,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () async {
                final Uri params = Uri(
                  scheme: 'mailto',
                  path: 'contact@decathlonpass.com',
                  query: 'subject=Contact support', //add subject and body here
                );

                var url = params.toString();
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Row(
                children: [
                  Container(
                    height: 56,
                    width: 56,
                    child: ClipOval(
                      child: Icon(
                        Icons.message_outlined,
                        color: Color.fromRGBO(0, 125, 188, 1),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    'contact@decathlonpass.com',
                    style: GoogleFonts.roboto(
                        height: 1.5,
                        fontSize: 16,
                        letterSpacing: -0.32,
                        color: Color.fromRGBO(0, 125, 188, 1),
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                const String _urlApp = "tel://+33457541109";

                if (await canLaunch(_urlApp)) {
                  await launch(_urlApp);
                } else {
                  throw 'Could not launch $_urlApp';
                }
              },
              child: Row(
                children: [
                  Container(
                    height: 56,
                    width: 56,
                    child: ClipOval(
                      child: Icon(
                        Icons.phone_outlined,
                        color: Color.fromRGBO(0, 125, 188, 1),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    '04 57 54 11 09',
                    style: GoogleFonts.roboto(
                        height: 1.5,
                        fontSize: 16,
                        letterSpacing: -0.32,
                        color: Color.fromRGBO(0, 125, 188, 1),
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
