import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class LoadingScaffold extends StatefulWidget {
  LoadingScaffold({Key? key}) : super(key: key);

  @override
  _LoadingScaffoldState createState() => _LoadingScaffoldState();
}

class _LoadingScaffoldState extends State<LoadingScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            height: 60,
            width: 60,
            child: CircularProgressIndicator(
              color: ColorsApp.BackgroundBrandPrimary,
              strokeWidth: 7,
            )),
      ),
    );
  }
}
