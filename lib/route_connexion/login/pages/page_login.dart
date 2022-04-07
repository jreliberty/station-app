import 'dart:async';
import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../blocs/login/login_bloc.dart';
import '../../../constants/colors.dart';
import '../../../constants/routes.dart';
import '../../identification/pages/page_identification.dart';
import '../../loading/loading.dart';

class MyChromeSafariBrowser extends ChromeSafariBrowser {
  @override
  void onOpened() {}

  @override
  void onCompletedInitialLoad() {}

  @override
  void onClosed() {}
}

ChromeSafariBrowser browserChrome = ChromeSafariBrowser();

class MyInAppBrowser extends InAppBrowser {
  final BuildContext context;
  MyInAppBrowser(this.context,
      {int? windowId, UnmodifiableListView<UserScript>? initialUserScripts})
      : super(windowId: windowId, initialUserScripts: initialUserScripts);

  @override
  Future onBrowserCreated() async {}

  @override
  Future onLoadStart(url) async {}

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();
    if (url != null) if (url
        .toString()
        .contains(Routes.API_IDENTIFICATION_TO_CONTAIN)) {
      BlocProvider.of<LoginBloc>(context).add(GetJwtTokenEvent(uri: url));
      close();
      browserChrome.close();
    }
  }

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
  }

  @override
  void onExit() {}

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(
      navigationAction) async {
    return NavigationActionPolicy.ALLOW;
  }
}

class PageLogin extends StatefulWidget {
  PageLogin({Key? key}) : super(key: key);

  @override
  _PageLoginState createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  List<Locale> languages = [Locale('fr', 'FR'), Locale('en', 'US')];

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state is GettingJwtInProgress) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoadingConnection()),
              (Route<dynamic> route) => false);
        }
        if (state is GettingUrlDone) {
          showCupertinoModalPopup(
              context: context, builder: (context) => PageIdentification());
          // await browserChrome.open(
          //     url: Uri.parse(state.url),
          //     options: ChromeSafariBrowserClassOptions(
          //         android: AndroidChromeCustomTabsOptions(
          //             addDefaultShareMenuItem: false),
          //         ios: IOSSafariOptions(barCollapsingEnabled: true)));

          // final MyInAppBrowser browser = new MyInAppBrowser(context);
          // try {
          //   await browser.close();
          // } catch (e) {}
          // await browser.openUrlRequest(
          //     urlRequest: URLRequest(
          //       url: Uri.parse(state.url),
          //       iosHttpShouldHandleCookies: true,
          //     ),
          //     options: InAppBrowserClassOptions(
          //         inAppWebViewGroupOptions: InAppWebViewGroupOptions(
          //           android: AndroidInAppWebViewOptions(
          //               supportMultipleWindows: true),
          //           crossPlatform: InAppWebViewOptions(
          //             useShouldOverrideUrlLoading: true,
          //             useOnLoadResource: true,
          //             userAgent:
          //                 "Mozilla/5.0 (Linux; Android 4.0.4; Galaxy Nexus Build/IMM76B) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.133 Mobile Safari/535.19",
          //           ),
          //         ),
          //         crossPlatform: InAppBrowserOptions(
          //             hideUrlBar: true, hideToolbarTop: false),
          //         android: AndroidInAppBrowserOptions()));
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color.fromRGBO(0, 125, 188, 1),
            image: DecorationImage(
              image: AssetImage("assets/login.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 16,
                ),
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 10.0),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(4.0),
                //     border: Border.all(color: Colors.white, width: 1),
                //   ),
                //   child: DropdownButtonHideUnderline(
                //     child: DropdownButton<int>(
                //         icon: Icon(
                //           CupertinoIcons.chevron_down,
                //           color: Colors.white,
                //           size: 14,
                //         ),
                //         dropdownColor: Colors.grey,
                //         style: GoogleFonts.roboto(
                //             height: 1.11,
                //             fontSize: 14,
                //              color: ColorsApp.ContentPrimaryReversed,
                //             fontWeight: FontWeight.w500),
                //         value: _indexLanguage,
                //         items: [
                //           DropdownMenuItem(
                //             child: Text("France - FR"),
                //             value: 0,
                //           ),
                //           DropdownMenuItem(
                //             child: Text("England - EN"),
                //             value: 1,
                //           )
                //         ],
                //         onChanged: (var value) {
                //           setState(() {
                //             _indexLanguage = value!;
                //             _chosenLanguage = languages[value];
                //           });
                //           EasyLocalization.of(context)!
                //               .setLocale(_chosenLanguage);
                //         },
                //         hint: Text("Select item")),
                //   ),
                // ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        tr('connection.login.title'),
                        textAlign: TextAlign.left,
                        style: GoogleFonts.roboto(
                            height: 1.11,
                            fontSize: 36,
                            //color: Color(#687787),
                            color: ColorsApp.ContentPrimaryReversed,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        tr('connection.login.subtitle'),
                        style: GoogleFonts.roboto(
                            height: 1.65,
                            fontSize: 17,
                            //color: Color(#687787),
                            color: ColorsApp.ContentPrimaryReversed,
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
                            primary: ColorsApp.ContentPrimaryReversed,
                          ),
                          onPressed: () async {
                            BlocProvider.of<LoginBloc>(context)
                                .add(GetUrlForLoginEvent());

                            // showCupertinoModalPopup(
                            //     context: context,
                            //     builder: (context) => PageIdentification());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person_outline,
                                color: Color.fromRGBO(0, 16, 21, 1),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    tr('connection.login.buttons.button1.label'),
                                    style: GoogleFonts.roboto(
                                        letterSpacing: 0.27,
                                        height: 1,
                                        fontSize: 16,
                                        color: ColorsApp.ContentPrimary,
                                        fontWeight: FontWeight.w700),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 36,
                      ),
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
