import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../blocs/newsletter/newsletter_bloc.dart';
import '../../../constants/colors.dart';

class PageNewsletterSubscribed extends StatefulWidget {
  PageNewsletterSubscribed({Key? key}) : super(key: key);

  @override
  _PageNewsletterSubscribedState createState() =>
      _PageNewsletterSubscribedState();
}

class _PageNewsletterSubscribedState extends State<PageNewsletterSubscribed> {
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
                    'Newsletter',
                    style: GoogleFonts.roboto(
                        height: 1.2,
                        fontSize: 20,
                        color: ColorsApp.ContentPrimary,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Image.asset(
              'assets/newsletter/newsletter.png',
            ),
            SizedBox(
              height: 26,
            ),
            Text(
              'Vous êtes abonné à la newsletter 🤓',
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
              'Vous pouvez vous désabonner à tout moment, même si cela nous brise le coeur de vous voir partir... 💔',
              style: GoogleFonts.roboto(
                  height: 1.65,
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(247, 248, 249, 1)),
                onPressed: () {
                  BlocProvider.of<NewsletterBloc>(context)
                      .add(UnsubscribeNewsletterEvent());
                },
                child: Center(
                  child: Text(
                    'Je me désabonne',
                    style: GoogleFonts.roboto(
                        height: 1,
                        fontSize: 16,
                        color: Color.fromRGBO(0, 104, 157, 1),
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
