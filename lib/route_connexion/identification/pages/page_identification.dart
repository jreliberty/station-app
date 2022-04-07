import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../blocs/login/login_bloc.dart';
import '../../../constants/colors.dart';
import '../../../constants/routes.dart';
import '../../loading/loading.dart';

class PageIdentification extends StatefulWidget {
  PageIdentification({Key? key}) : super(key: key);

  @override
  _PageIdentificationState createState() => _PageIdentificationState();
}

class _PageIdentificationState extends State<PageIdentification> {
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
      if (url.toString().contains(Routes.API_IDENTIFICATION_TO_CONTAIN)) {
        BlocProvider.of<LoginBloc>(context)
            .add(GetJwtTokenEvent(uri: Uri.parse(url)));
        flutterWebViewPlugin.close();
      }
    });

    _onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        print(state);
      }
    });

    _onHttpError =
        flutterWebViewPlugin.onHttpError.listen((WebViewHttpError error) {
      if (mounted) print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is GettingJwtInProgress)
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoadingConnection()),
              (Route<dynamic> route) => false);
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is GettingUrlDone)
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
                      child: Column(
                        children: [
                          Container(
                            height: 55,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Color.fromRGBO(239, 241, 243, 1),
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.clear),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    tr('connection.loginWebview.title'),
                                    style: GoogleFonts.roboto(
                                        height: 1.5,
                                        fontSize: 16,
                                        //color: Color(#687787),
                                        color: ColorsApp.ContentPrimary,
                                        fontWeight: FontWeight.w700),
                                  ),
                                )
                              ],
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
                                        clearCookies: false,
                                        clearCache: false,
                                        appCacheEnabled: true,
                                        url: state.url,
                                        mediaPlaybackRequiresUserGesture: false,
                                        withZoom: true,
                                        withLocalStorage: true,
                                        withJavascript: true,
                                        debuggingEnabled: false,
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
                    ),
                  )
                ],
              ),
            );
          else
            return CircularProgressIndicator();
        },
      ),
    );
  }
}
