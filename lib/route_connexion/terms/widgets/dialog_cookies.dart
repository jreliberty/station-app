import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';

class DialogCookies extends StatefulWidget {
  final InAppBrowser browser = InAppBrowser();

  @override
  State<DialogCookies> createState() => _DialogCookiesState();
}

class _DialogCookiesState extends State<DialogCookies> {
  bool isAllOn = true;
  bool isOn = true;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(16, 20, 24, 16),
        elevation: 10,
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(
              'Revenir',
              style: GoogleFonts.roboto(
                  fontSize: 16,
                  //color: Color(#687787),
                  color: Colors.black,
                  fontWeight: FontWeight.w700),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(
              'Terminer',
              style: GoogleFonts.roboto(
                  fontSize: 16,
                  //color: Color(#687787),
                  color: Color.fromRGBO(0, 104, 157, 1),
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Voici nos cookies !',
              style: GoogleFonts.roboto(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Diététiques et complétement inoffensifs',
              style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
        content: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Tout cocher',
                    style: GoogleFonts.roboto(
                        fontSize: 18,
                        color: Colors.black87,
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.left,
                  ),
                  Transform.scale(
                    scale: 1.5,
                    child: new Switch(
                        value: isAllOn,
                        onChanged: (bool newValue) {
                          setState(() {
                            isAllOn = newValue;
                            isOn = newValue;
                          });
                        }),
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListTile(
                        leading: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/google.png",
                              width: 15,
                              height: 15,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            GestureDetector(
                              onTap: () async {
                                await widget.browser.openUrlRequest(
                                    urlRequest: URLRequest(
                                      url: Uri.parse(
                                          "https://support.google.com/analytics/answer/6004245?hl=fr"),
                                    ),
                                    options: InAppBrowserClassOptions(
                                      inAppWebViewGroupOptions:
                                          InAppWebViewGroupOptions(
                                        crossPlatform: InAppWebViewOptions(),
                                      ),
                                      crossPlatform: InAppBrowserOptions(
                                          hideUrlBar: true,
                                          hideToolbarTop: false),
                                    ));
                              },
                              child: ClipOval(
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  color: Colors.grey,
                                  child: Icon(
                                    FlutterRemix.question_mark,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        dense: true,
                        contentPadding: const EdgeInsets.all(0),
                        title: Text(
                          'Google Analytics',
                          style: GoogleFonts.roboto(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                        subtitle: Text(
                          'Permet d\'analyser les statistiques de consultation de notre site',
                          style: GoogleFonts.roboto(
                              fontSize: 10,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400),
                        ),
                        minLeadingWidth: 0,
                        visualDensity:
                            VisualDensity(horizontal: -4, vertical: 0)),
                  ),
                  Switch(
                    onChanged: (bool newValue) {
                      setState(() {
                        isOn = newValue;
                        isAllOn = newValue;
                      });
                    },
                    value: isOn,
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
