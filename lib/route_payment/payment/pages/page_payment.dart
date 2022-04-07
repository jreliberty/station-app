import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../blocs/payment/payment_bloc.dart';
import '../../../constants/colors.dart';
import '../../../constants/config.dart';
import '../../../core/utils/loading.dart';
import '../../../entities/order/order.dart';
import '../../../entities/payment/card_payment.dart';
import '../../confirmation_payment/pages/page_payment_error.dart';
import '../../confirmation_payment/pages/page_payment_succeed.dart';
import '../../redirect/redirect.dart';

class PagePayment extends StatefulWidget {
  final Order order;
  PagePayment({Key? key, required this.order}) : super(key: key);

  @override
  _PagePaymentState createState() => _PagePaymentState();
}

class _PagePaymentState extends State<PagePayment> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  // On urlChanged stream
  late StreamSubscription<String> _onUrlChanged;

  // On urlChanged stream
  late StreamSubscription<WebViewStateChanged> _onStateChanged;

  late StreamSubscription<WebViewHttpError> _onHttpError;

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();

    flutterWebViewPlugin.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Add a listener to on url changed
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      print(url);
    });

    _onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        print(state);
      }
    });

    _onHttpError =
        flutterWebViewPlugin.onHttpError.listen((WebViewHttpError error) {
      if (mounted) print('error : ' + error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: BlocListener<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentLoadSuccess) {
            if (state.paymentResponse.redirect)
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => Redirect(
                      redirectHtml: state.paymentResponse.redirectHtml)));
            else if (state.paymentResponse.success)
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => PagePaymentSucceed()));
            else {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => PagePaymentError()));
            }
          }
        },
        child: Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      color: const Color.fromRGBO(247, 248, 249, 1),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 24.0, right: 24, left: 10),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(FlutterRemix.arrow_left_line),
                              color: ColorsApp.ContentPrimary,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Text(
                                    'Paiement sécurisé',
                                    style: GoogleFonts.roboto(
                                        height: 1.2,
                                        fontSize: 20,
                                        color: ColorsApp.ContentPrimary,
                                        fontWeight: FontWeight.w700),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 0,
                      thickness: 1,
                      color: ColorsApp.ContentDivider,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(10.0),
                                child: WebviewScaffold(
                                  javascriptChannels: {
                                    JavascriptChannel(
                                        name: 'JavascriptChannel',
                                        onMessageReceived: (message) async {
                                          print(
                                              'Javascript: ${message.message}');
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          var cardPayment =
                                              CardPayment.fromString(
                                            data: message.message,
                                            orderToken: widget.order.token,
                                            orderId: widget.order.id,
                                          );
                                          print(cardPayment);
                                          BlocProvider.of<PaymentBloc>(context)
                                              .add(CreatePaymentEvent(
                                                  cardPayment: cardPayment));
                                        }),
                                    JavascriptChannel(
                                        name: 'JavascriptChannelOpenCGV',
                                        onMessageReceived: (message) async {
                                          print(
                                              'Javascript: ${message.message}');
                                          launch(MyConfig.BASE_URL_MEDIA +
                                              "docs/files/cgv/${widget.order.contractorId}.pdf");
                                        })
                                  },
                                  ignoreSSLErrors: true,
                                  withOverviewMode: true,
                                  allowFileURLs: true,
                                  clearCookies: false,
                                  clearCache: false,
                                  appCacheEnabled: true,
                                  url: MyConfig.PAYMENT_FORM_URL,
                                  mediaPlaybackRequiresUserGesture: false,
                                  withZoom: true,
                                  withLocalStorage: true,
                                  withJavascript: true,
                                  debuggingEnabled: true,
                                  supportMultipleWindows: true,
                                  userAgent: Platform.isIOS
                                      ? 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_1_2 like Mac OS X) AppleWebKit/605.1.15' +
                                          ' (KHTML, like Gecko) Version/13.0.1 Mobile/15E148 Safari/604.1'
                                      : 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) ' +
                                          'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36',
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                BlocBuilder<PaymentBloc, PaymentState>(
                  builder: (context, state) {
                    if (state is PaymentLoadInProgress) return Loading();
                    return Container();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
