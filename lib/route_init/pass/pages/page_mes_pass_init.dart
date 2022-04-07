import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../blocs/consumer/consumer_bloc.dart';
import '../../../constants/colors.dart';
import '../../../core/utils/page_creation_pass.dart';
import '../widgets/pass_card_init.dart';

class PageMesPassInit extends StatefulWidget {
  final TabController controller;
  PageMesPassInit({Key? key, required this.controller}) : super(key: key);

  @override
  _PageMesPassInitState createState() => _PageMesPassInitState();
}

class _PageMesPassInitState extends State<PageMesPassInit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overScroll) {
                  overScroll.disallowIndicator();
                  return false;
                },
                child: ListView(children: [
                  // Align(
                  //   alignment: Alignment.topLeft,
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(20),
                  //         color: Color.fromRGBO(239, 241, 243, 1)),
                  //     height: 40,
                  //     width: 40,
                  //     child: IconButton(
                  //       icon: Icon(Icons.arrow_back),
                  //       color: ColorsApp.ContentPrimary,
                  //       onPressed: () {
                  //         widget.controller.animateTo(2);
                  //       },
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 16),
                    child: Text(
                      tr('configuration.pass.title'),
                      style: GoogleFonts.roboto(
                          fontSize: 36,
                          color: ColorsApp.ContentPrimary,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Text(
                    tr('configuration.pass.subtitle'),
                    style: GoogleFonts.roboto(
                        letterSpacing: -0.24,
                        fontSize: 15,
                        //color: Color(#687787),
                        color: ColorsApp.ContentTertiary,
                        fontWeight: FontWeight.w400),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: ColorsApp.BackgroundBrandSecondary,
                        ),
                        onPressed: () {
                          showCupertinoModalPopup(
                              context: context,
                              builder: (context) => PageCreationPass(
                                    contact: null,
                                  ));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: ColorsApp.ContentAction,
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  tr('configuration.pass.buttons.button1.label'),
                                  style: GoogleFonts.roboto(
                                      fontSize: 15,
                                      color: ColorsApp.ContentAction,
                                      fontWeight: FontWeight.w700),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  BlocBuilder<ConsumerBloc, ConsumerState>(
                    builder: (context, state) {
                      if (state is ConsumerLoadSuccess) {
                        state.user.contacts
                            .sort((a, b) => a.index.compareTo(b.index));
                        return Column(
                          children: state.user.contacts
                              .map((e) => (e.middleName == 'deleted')
                                  ? Container()
                                  : PassCardInit(
                                      contact: e,
                                    ))
                              .toList(),
                        );
                      } else
                        return Container();
                    },
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 56,
                    child: ElevatedButton(
                        onPressed: () async {
                          var prefs = await SharedPreferences.getInstance();
                          await prefs.setString('init', 'true');
                          widget.controller.animateTo(4);
                        },
                        child: Text(
                          tr('configuration.pass.buttons.button2.label'),
                          style: GoogleFonts.roboto(
                              fontSize: 15,
                              color: ColorsApp.ContentPrimaryReversed,
                              fontWeight: FontWeight.w700),
                        )),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
