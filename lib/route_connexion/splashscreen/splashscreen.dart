import 'dart:async';

import 'package:airplane_mode_detection/airplane_mode_detection.dart';
import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/errors/page_airplane_mode.dart';
import '../../repository/helpers/api_helper.dart';
import '../login/pages/page_login.dart';
import '../terms/pages/page_terms.dart';
import 'bot_clipper.dart';
import 'top_clipper.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool animate = false;
  bool display = false;
  bool goToTerms = true;

  var squareScale = 0.5;
  late AnimationController _controllerAnimation;

  @override
  void initState() {
    super.initState();
    _controllerAnimation = AnimationController(
        vsync: this,
        lowerBound: 0.5,
        upperBound: 1.0,
        duration: Duration(milliseconds: 400));
    _controllerAnimation.addListener(() {
      setState(() {
        squareScale = _controllerAnimation.value;
      });
    });
    init();
  }

  init() async {
    await Jiffy.locale("fr");
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('cookies') != null) {
      goToTerms = false;
    }
    ApiHelper apiHelper = ApiHelper();
    var token = await apiHelper.getCachedToken(init: true);
    print(token.token);
    bool hasExpired = true;
    if (token.token != '') {
      hasExpired = JwtDecoder.isExpired(token.token);
    }
    Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        animate = true;
      });
    });
    Future.delayed(Duration(milliseconds: 2500), () {
      setState(() {
        display = true;
        _controllerAnimation.forward();
      });
    });
    Future.delayed(Duration(milliseconds: 4000), () async {
      String airplaneMode;
      try {
        airplaneMode = await AirplaneModeDetection.detectAirplaneMode();
      } on PlatformException {
        airplaneMode = 'Failed to get AirPlane Mode.';
      }
      bool isAirplaneModeOn = (airplaneMode == "ON") ? true : false;
      if (isAirplaneModeOn)
        await showCupertinoModalPopup(
            context: context, builder: (context) => PageAirplaneMode());
      if (goToTerms)
        showCupertinoModalPopup(
            context: context, builder: (context) => PageTerms());
      else {
        showCupertinoModalPopup(
            context: context, builder: (context) => PageLogin());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/splashscreen/skieur.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          TranslationAnimatedWidget(
            enabled: animate, //will forward/reverse the animation
            curve: Curves.ease,
            duration: Duration(milliseconds: 400),
            values: [
              Offset(-MediaQuery.of(context).size.height / 2,
                  -MediaQuery.of(context).size.width / 2),
              Offset(0, 0),
            ],

            child: ClipPath(
              clipper: TopClipper(),
              child: Container(
                  child: Image.asset(
                "assets/splashscreen/fond.png",
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              )),
            ),
          ),
          TranslationAnimatedWidget(
            enabled: animate, //will forward/reverse the animation
            curve: Curves.ease,
            duration: Duration(milliseconds: 400),
            values: [
              Offset(MediaQuery.of(context).size.height / 2,
                  MediaQuery.of(context).size.width / 2),
              Offset(0, 0),
            ],

            child: ClipPath(
              clipper: BotClipper(),
              child: Container(
                color: Color.fromRGBO(1, 43, 73, 1),
              ),
            ),
          ),
          Transform.scale(
            scale: 1 / squareScale,
            child: OpacityAnimatedWidget.tween(
              opacityEnabled: 1, //define start value
              opacityDisabled: 0, //and end value
              enabled: display, //bind with the boolean
              child: Center(
                  child: Container(
                      child: Image.asset(
                "assets/splashscreen/logo-baseline-rvb.png",
                height: 130,
                width: 270,
                //fit: BoxFit.cover,
              ))),
            ),
          )
          /*TopCustomPainter.splashScreen(
                      child: Text('data'),
                      size: MediaQuery.of(context).size,
                      image: image),*/
          /*BottomCustomPainter.splashScreen(
                      child: Text('data'), size: MediaQuery.of(context).size)*/
        ],
      )
    );
  }
}
