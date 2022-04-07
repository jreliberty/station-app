import 'package:flutter/material.dart';

import 'page_first_pass.dart';
import 'page_pass.dart';

class PageTabPass extends StatefulWidget {
  final int initialIndex;
  PageTabPass({Key? key, required this.initialIndex}) : super(key: key);

  @override
  _PageTabPassState createState() => _PageTabPassState();
}

class _PageTabPassState extends State<PageTabPass>
    with TickerProviderStateMixin {
  late TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(
        length: 2, vsync: this, initialIndex: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _controller,
          children: <Widget>[
            PageFirstPass(controller: _controller),
            PagePass()
          ]),
    );
  }
}
