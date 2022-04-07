import 'package:flutter/material.dart';

import 'adress/pages/page_adress_init.dart';
import 'done_init/pages/page_done_init.dart';
import 'done_init/pages/page_done_init_empty.dart';
import 'pass/pages/page_first_pass_init.dart';
import 'pass/pages/page_mes_pass_init.dart';
import 'personal_info/pages/page_personal_info_init.dart';

class PageInitTabBar extends StatefulWidget {
  PageInitTabBar({Key? key}) : super(key: key);

  @override
  _PageInitTabBarState createState() => _PageInitTabBarState();
}

class _PageInitTabBarState extends State<PageInitTabBar>
    with TickerProviderStateMixin {
  late TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 6, vsync: this);
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _controller,
            children: <Widget>[
              PagePersonalInfoInit(controller: _controller),
              PageAdressInit(controller: _controller),
              PageFirstPassInit(controller: _controller),
              PageMesPassInit(controller: _controller),
              PageDoneInit(),
              PageDoneInitEmpty(),
            ]),
      ),
    );
  }
}
