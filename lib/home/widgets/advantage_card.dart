import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/colors.dart';
import '../../entities/advantage.dart';
import '../../profile/home/widgets/browser_webview.dart';

var formatDate = new DateFormat("d MMM yyyy", 'fr');
var formatDateNoYear = new DateFormat("d MMM", 'fr');

class AdvantageCard extends StatelessWidget {
  final Advantage advantage;
  final InAppBrowser browser = InAppBrowser();
  AdvantageCard({Key? key, required this.advantage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: GestureDetector(
        onTap: () async {
          if (advantage.redirectUrl != "") {
            if (advantage.redirectUrl.contains("t.me")) {
              if (await canLaunch(advantage.redirectUrl)) {
                await launch(advantage.redirectUrl);
                return;
              } else
                print("couldn't launch ${advantage.redirectUrl}");
            }
            await showCupertinoModalPopup(
                context: context,
                builder: (context) => BrowserWebview(
                      url: advantage.redirectUrl,
                    ));
          }
        },
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 8,
          shadowColor: Color.fromRGBO(0, 83, 125, 0.15),
          child: Container(
            height: 500,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child:
                      /*Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: advantage.image,
                  ),*/
                      ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                          child: advantage.image),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(advantage.title,
                            style: TextStyle(
                                height: 1.2,
                                color: ColorsApp.ContentPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.w700)),
                      ),
                      MarkdownBody(
                          data: advantage.description.replaceAll("\\n", "\n")),
                      // Text(advantage.description,
                      //     style: TextStyle(
                      //         height: 1.65,
                      //         color: ColorsApp.ContentPrimary,
                      //         fontSize: 17,
                      //         fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
