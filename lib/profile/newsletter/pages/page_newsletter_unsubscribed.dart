import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../blocs/newsletter/newsletter_bloc.dart';
import '../../../constants/colors.dart';

class PageNewsletterUnsubscribed extends StatefulWidget {
  PageNewsletterUnsubscribed({Key? key}) : super(key: key);

  @override
  _PageNewsletterUnsubscribedState createState() =>
      _PageNewsletterUnsubscribedState();
}

class _PageNewsletterUnsubscribedState
    extends State<PageNewsletterUnsubscribed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
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
                  'Abonne-toi à notre newsletter 🤓',
                  style: GoogleFonts.roboto(
                      height: 1.11,
                      fontSize: 34,
                      color: ColorsApp.ContentPrimary,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      FlutterRemix.check_fill,
                      color: Color.fromRGBO(35, 169, 66, 1),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Les meilleurs offres en avant première',
                      style: GoogleFonts.roboto(
                          height: 1.65,
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      overflow: TextOverflow.clip,
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      FlutterRemix.check_fill,
                      color: Color.fromRGBO(35, 169, 66, 1),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Nouvelles stations disponibles',
                      style: GoogleFonts.roboto(
                          height: 1.65,
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      overflow: TextOverflow.clip,
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      FlutterRemix.check_fill,
                      color: Color.fromRGBO(35, 169, 66, 1),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Nos conseils ski...',
                      style: GoogleFonts.roboto(
                          height: 1.65,
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      overflow: TextOverflow.clip,
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(0, 125, 188, 1)),
                    onPressed: () {
                      BlocProvider.of<NewsletterBloc>(context)
                          .add(SubscribeNewsletterEvent());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          FlutterRemix.mail_line,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 14),
                          child: Text(
                            'Je m’abonne',
                            style: GoogleFonts.roboto(
                                height: 1,
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
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
                        primary: Color.fromRGBO(247, 248, 249, 1)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: Text(
                        'Pas pour l\'instant',
                        style: GoogleFonts.roboto(
                            height: 1,
                            fontSize: 16,
                            color: Color.fromRGBO(0, 104, 157, 1),
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
