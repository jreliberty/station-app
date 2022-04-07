import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../confirmation_payment/pages/page_payment_error.dart';
import '../confirmation_payment/pages/page_payment_succeed.dart';

class Redirect extends StatefulWidget {
  final String redirectHtml;
  Redirect({Key? key, required this.redirectHtml}) : super(key: key);

  @override
  _RedirectState createState() => _RedirectState();
}

class _RedirectState extends State<Redirect> {
  bool isSaved = false;
  bool isAccepted = false;
  bool isInitialLoaded = false;
  late WebViewPlusController controller;
  @override
  void initState() {
    isInitialLoaded = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        body: Stack(
          children: [
            ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Opacity(
                    opacity: isInitialLoaded ? 1 : 0,
                    child: WebViewPlus(
                      onPageFinished: (url) {
                        if (!isInitialLoaded) {
                          setState(() => isInitialLoaded = true);
                        }
                      },
                      onPageStarted: (url) {
                        print(url);
                        if (url.contains('/payment')) if (isInitialLoaded) {
                          setState(() => isInitialLoaded = false);
                        }
                        if (url.contains('/payment/result')) {
                          var queryParameters = Uri.parse(url).queryParameters;
                          if (queryParameters['EXECCODE'] == "0000" &&
                              queryParameters['MESSAGE']!.contains('succeeded'))
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        PagePaymentSucceed()));
                          else
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        PagePaymentError()));
                        } else if (url.contains('/payment/cancelled'))
                          Navigator.of(context).pop();
                      },
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (controller) {
                        this.controller = controller;
                        controller.loadString(widget.redirectHtml);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
