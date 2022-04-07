import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/colors.dart';

class PageMaintenance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              child: Stack(
            children: <Widget>[
              Container(
                child: FlareActor(
                  'assets/maintenanceFinal.flr',
                  alignment: Alignment.center,
                  // fit: BoxFit.cover,
                  animation: 'coding',
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(FlutterRemix.arrow_left_line),
                        color: ColorsApp.ContentPrimary,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 48, left: 48),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey,
                        border: Border.all(color: Colors.white, width: .8)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Cette partie de l'application est en maintenance, elle sera bientôt disponible avec un design qui pétille !",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  Expanded(flex: 1, child: Container()),
                  Container(
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.07),
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.grey),
                        child: Text(
                          'Mettre la pression au dev',
                          style: GoogleFonts.roboto(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        ),
                        onPressed: () async {
                          const String _urlApp = "tel://+33604517727";

                          if (await canLaunch(_urlApp)) {
                            await launch(_urlApp);
                          } else {
                            throw 'Could not launch $_urlApp';
                          }
                        },
                      ),
                    ),
                  ),
                ],
              )
            ],
          )),
        ],
      ),
    );
  }
}
