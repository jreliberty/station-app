import 'dart:async';

import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

// ignore: must_be_immutable
class ImagePickerDialog extends StatelessWidget {
  AnimationController _controller;
  late BuildContext context;

  ImagePickerDialog(this._controller);

  late Animation<double> _drawerContentsOpacity;
  late Animation<Offset> _drawerDetailsPosition;

  String type = 'cancel';

  void initState() {
    _drawerContentsOpacity = new CurvedAnimation(
      parent: new ReverseAnimation(_controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = new Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(new CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));
    type = 'cancel';
  }

  Future<String> getImage(BuildContext context) async {
    _controller.forward();
    String mode = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => new SlideTransition(
        position: _drawerDetailsPosition,
        child: new FadeTransition(
          opacity: new ReverseAnimation(_drawerContentsOpacity),
          child: this,
        ),
      ),
    );
    return mode;
  }

  void dispose() {
    _controller.dispose();
  }

  startTime() async {
    var _duration = new Duration(milliseconds: 200);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pop(context, type);
  }

  dismissDialog(String typeimage) {
    _controller.reverse();
    type = typeimage;
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return new Material(
        type: MaterialType.transparency,
        child: new Opacity(
          opacity: 1.0,
          child: new Container(
            padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new GestureDetector(
                  onTap: () => dismissDialog('camera'),
                  child: roundedButton(
                      "Caméra",
                      EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      ColorsApp.BackgroundBrandSecondary,
                      const Color.fromRGBO(0, 104, 157, 1)),
                ),
                new GestureDetector(
                  onTap: () => dismissDialog('gallery'),
                  child: roundedButton(
                      "Galerie",
                      EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      ColorsApp.BackgroundBrandSecondary,
                      const Color.fromRGBO(0, 104, 157, 1)),
                ),
                const SizedBox(height: 15.0),
                new GestureDetector(
                  onTap: () => dismissDialog('cancel'),
                  child: new Padding(
                    padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                    child: roundedButton(
                        "Annuler",
                        EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                        ColorsApp.BackgroundBrandSecondary,
                        const Color.fromRGBO(0, 104, 157, 1)),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget roundedButton(
      String buttonLabel, EdgeInsets margin, Color bgColor, Color textColor) {
    var loginBtn = new Container(
      margin: margin,
      padding: EdgeInsets.all(15.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: bgColor,
        borderRadius: new BorderRadius.all(const Radius.circular(15.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF696969),
            offset: Offset(1.0, 6.0),
            blurRadius: 0.001,
          ),
        ],
      ),
      child: Text(
        buttonLabel,
        style: new TextStyle(
            color: textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
    return loginBtn;
  }
}
