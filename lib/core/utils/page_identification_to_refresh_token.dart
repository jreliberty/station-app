// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../route_connexion/splashscreen/splashscreen.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../../../blocs/login/login_bloc.dart';
// import '../../../constants/routes.dart';

// class PageIdentificationToRefreshToken extends StatefulWidget {
//   PageIdentificationToRefreshToken({Key? key}) : super(key: key);

//   @override
//   _PageIdentificationToRefreshTokenState createState() =>
//       _PageIdentificationToRefreshTokenState();
// }

// class _PageIdentificationToRefreshTokenState
//     extends State<PageIdentificationToRefreshToken> {
//   var cookies = IOSCookieManager.instance();

//   InAppWebViewController? webViewController;
//   InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
//       crossPlatform: InAppWebViewOptions(
//         useShouldOverrideUrlLoading: true,
//         mediaPlaybackRequiresUserGesture: false,
//         incognito: false,
//       ),
//       android: AndroidInAppWebViewOptions(
//         useHybridComposition: true,
//       ),
//       ios: IOSInAppWebViewOptions(
//         // allowsInlineMediaPlayback: true,
//         sharedCookiesEnabled: true,
//       ));

//   late PullToRefreshController pullToRefreshController;
//   late ContextMenu contextMenu;
//   String url = "";
//   double progress = 0;
//   final urlController = TextEditingController();

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<LoginBloc, LoginState>(
//       listener: (context, state) {
//         if (state is GettingJwtDone)
//           Navigator.of(context).pop(state.token);
//         else if (state is GettingJwtFailure) {
//           Navigator.of(context).pushReplacement(MaterialPageRoute(
//               builder: (BuildContext context) => SplashScreen()));
//         }
//       },
//       child: BlocBuilder<LoginBloc, LoginState>(
//         builder: (context, state) {
//           if (state is GettingUrlDone)
//             return Material(
//               type: MaterialType.transparency,
//               child: Column(
//                 children: [
//                   Container(
//                     height: 44,
//                     width: MediaQuery.of(context).size.width,
//                     color: Colors.transparent,
//                   ),
//                   Expanded(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(16),
//                           topRight: Radius.circular(16),
//                         ),
//                         color: Colors.white,
//                       ),
//                       child: Column(
//                         children: [
//                           Container(
//                             height: 55,
//                             width: MediaQuery.of(context).size.width,
//                             child: Stack(
//                               children: [
//                                 Align(
//                                   alignment: Alignment.centerLeft,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Container(
//                                       height: 40,
//                                       width: 40,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(20),
//                                         color: Color.fromRGBO(239, 241, 243, 1),
//                                       ),
//                                       child: IconButton(
//                                         icon: Icon(Icons.clear),
//                                         onPressed: () {
//                                           Navigator.of(context).pop();
//                                         },
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Center(
//                                   child: Text(
//                                     tr('connection.loginWebview.title'),
//                                     style: GoogleFonts.roboto(
//                                         height: 1.5,
//                                         fontSize: 16,
//                                         //color: Color(#687787),
//                                         color: ColorsApp.ContentPrimary,
//                                         fontWeight: FontWeight.w700),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           Divider(
//                             height: 0,
//                             thickness: 1,
//                             color: ColorsApp.ContentDivider,
//                           ),
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.all(0.0),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   Expanded(
//                                     child: Container(
//                                       margin: const EdgeInsets.all(10.0),
//                                       child: InAppWebView(
//                                         initialUrlRequest: URLRequest(
//                                             url: Uri.parse(state.url)),
//                                         initialOptions:
//                                             InAppWebViewGroupOptions(
//                                           crossPlatform: InAppWebViewOptions(
//                                             javaScriptEnabled: true,
//                                             cacheEnabled: true,
//                                             supportZoom: false,
//                                             clearCache: false,
//                                             transparentBackground: true,
//                                             useShouldOverrideUrlLoading: true,
//                                           ),
//                                         ),
//                                         onWebViewCreated: (controller) {
//                                           webViewController = controller;
//                                         },
//                                         onLoadStart: (controller, url) {},
//                                         androidOnPermissionRequest: (controller,
//                                             origin, resources) async {
//                                           return PermissionRequestResponse(
//                                               resources: resources,
//                                               action:
//                                                   PermissionRequestResponseAction
//                                                       .GRANT);
//                                         },
//                                         shouldOverrideUrlLoading: (controller,
//                                             navigationAction) async {
//                                           var uri =
//                                               navigationAction.request.url!;

//                                           if (![
//                                             "http",
//                                             "https",
//                                             "file",
//                                             "chrome",
//                                             "data",
//                                             "javascript",
//                                             "about"
//                                           ].contains(uri.scheme)) {
//                                             if (await canLaunch(url)) {
//                                               // Launch the App
//                                               await launch(
//                                                 url,
//                                               );
//                                               // and cancel the request
//                                               return NavigationActionPolicy
//                                                   .CANCEL;
//                                             }
//                                           }

//                                           return NavigationActionPolicy.ALLOW;
//                                         },
//                                         onLoadStop: (controller, url) async {
//                                           if (url != null) if (url
//                                               .toString()
//                                               .contains(Routes
//                                                   .API_IDENTIFICATION_TO_CONTAIN)) {
//                                             print('alle 4');
//                                             BlocProvider.of<LoginBloc>(context)
//                                                 .add(
//                                                     GetJwtTokenEvent(uri: url));
//                                           }
//                                         },
//                                         onLoadError:
//                                             (controller, url, code, message) {
//                                           pullToRefreshController
//                                               .endRefreshing();
//                                         },
//                                         onConsoleMessage:
//                                             (controller, consoleMessage) {
//                                           print('console  ' +
//                                               consoleMessage.toString());
//                                         },
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 8,
//                                   )
//                                 ],
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             );
//           else
//             return CircularProgressIndicator();
//         },
//       ),
//     );
//   }
// }
