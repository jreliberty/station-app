import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';

import '../../../blocs/cart/cart_bloc.dart';
import '../../../blocs/stations/stations_bloc.dart';
import '../../../bottom_tab_bar/pages/page_bottom_tab_bar.dart';
import '../../../constants/colors.dart';
import '../../../core/utils/loading.dart';
import '../../../entities/station.dart';
import '../../pass/pages/page_selection_pass.dart';
import '../widgets/domain_card.dart';

class PageDomaines extends StatefulWidget {
  final DateTime? startDate;
  final Station station;
  PageDomaines({Key? key, required this.station, required this.startDate})
      : super(key: key);

  @override
  _PageDomainesState createState() => _PageDomainesState();
}

class _PageDomainesState extends State<PageDomaines> {
  late RiveAnimationController _controller;

  // Toggles between play and pause animation states
  void _togglePlay() =>
      setState(() => _controller.isActive = !_controller.isActive);

  /// Tracks if the animation is playing by whether controller is running
  bool get isPlaying => _controller.isActive;
  late Station station;
  late DateTime? startDate;
  @override
  void initState() {
    _controller = SimpleAnimation('Animation 1');
    _togglePlay();
    super.initState();
    station = widget.station;
    print(widget.station);
    startDate = widget.startDate;
    //   Future.delayed(Duration(seconds: 3), () {
    //     _togglePlay();
    //   });
    //   Future.delayed(Duration(seconds: 7), () {
    //     _togglePlay();
    //   });
  }

  bool canGo = true;
  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) async {
        if (state is CartLoadSuccess) if (canGo) {
          canGo = false;
          canGo = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      PageSelectionPass(station: station))) ??
              true;
        }
      },
      child: BlocBuilder<StationsBloc, StationsState>(
        builder: (context, stateStations) {
          if (stateStations is StationsLoadSuccess) {
            station = stateStations.selectedStation!;
            startDate = stateStations.date;
          }
          return BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              return Scaffold(
                  body: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    alignment: Alignment.topCenter,
                    image: AssetImage("assets/patterns/PatternDomain.png"),
                  ),
                ),
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overScroll) {
                    overScroll.disallowIndicator();
                    return false;
                  },
                  child: Stack(
                    children: [
                      ListView(
                        padding: EdgeInsets.all(0),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 24,
                              left: 10,
                            ),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                icon: Icon(FlutterRemix.arrow_left_line),
                                color: ColorsApp.ContentPrimary,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 24,
                            ),
                            child: Text(
                              station.name,
                              style: GoogleFonts.roboto(
                                  height: 1.11,
                                  fontSize: 36,
                                  //color: Color(#687787),
                                  color: ColorsApp.ContentPrimary,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          (station.domains.length > 1)
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                    left: 24,
                                    top: 8,
                                  ),
                                  child: Text(
                                    'Pensez à scroller sur la droite pour voir tous nos domaines !',
                                    style: GoogleFonts.roboto(
                                        letterSpacing: -0.24,
                                        fontSize: 15,
                                        //color: Color(#687787),
                                        color: ColorsApp.ContentTertiary,
                                        fontWeight: FontWeight.w400),
                                  ),
                                )
                              : Container(),
                          BlocBuilder<StationsBloc, StationsState>(
                            builder: (context, state) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: station.domains
                                          .map((e) => DomainCard(
                                                domain: e,
                                                station: station,
                                                startDate: startDate,
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                          SizedBox(
                            height: 24,
                          )
                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //     left: 24,
                          //   ),
                          //   child: Container(
                          //     height: 550, //585,
                          //     child: ListView.builder(
                          //       shrinkWrap: true,
                          //       padding: EdgeInsets.only(top: 0, right: 24),
                          //       scrollDirection: Axis.horizontal,
                          //       itemCount: widget.domains.length,
                          //       itemBuilder: (context, index) {
                          //         return DomainCard(
                          //           domain: widget.domains[index],
                          //           station: widget.station,
                          //           startDate: widget.startDate,
                          //         );
                          //       },
                          //     ),
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //       top: 32, right: 24, bottom: 32, left: 24),
                          //   child: Container(
                          //     decoration: BoxDecoration(
                          //         color: ColorsApp.BackgroundBrandSecondary,
                          //         borderRadius: BorderRadius.circular(8)),
                          //     child: Row(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       mainAxisAlignment: MainAxisAlignment.start,
                          //       children: [
                          //         Padding(
                          //           padding: const EdgeInsets.all(16.0),
                          //           child: Icon(CupertinoIcons.info_circle),
                          //         ),
                          //         Expanded(
                          //           child: Padding(
                          //             padding: const EdgeInsets.only(
                          //                 top: 9.0, bottom: 9, right: 20),
                          //             child: Text(
                          //               tr('orders.domain.info'),
                          //               style: GoogleFonts.roboto(
                          //                   height: 1.7,
                          //                   fontSize: 13,
                          //                   //color: Color(#687787),
                          //                   color: ColorsApp.ContentPrimary,
                          //                   fontWeight: FontWeight.w400),
                          //             ),
                          //           ),
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(height: 32,),
                          // Container(
                          //   height: 56,
                          //   width: double.infinity,
                          //   decoration: BoxDecoration(
                          //     border: Border(
                          //       top: BorderSide(
                          //         color: ColorsApp.ContentDivider,
                          //         width: 1.0,
                          //       ),
                          //       bottom: BorderSide(
                          //         color: ColorsApp.ContentDivider,
                          //         width: 1.0,
                          //       ),
                          //     ),
                          //   ),
                          //   child: Row(
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       Padding(
                          //         padding:
                          //             const EdgeInsets.only(left: 25.0, right: 17),
                          //         child: Icon(CupertinoIcons.airplane),
                          //       ),
                          //       Expanded(
                          //         child: Column(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           crossAxisAlignment: CrossAxisAlignment.start,
                          //           children: [
                          //             Text(
                          //               tr('orders.domain.items.item1.title'),
                          //               style: GoogleFonts.roboto(
                          //                   fontSize: 15,
                          //                   //color: Color(#687787),
                          //                   color: ColorsApp.ContentPrimary,
                          //                   fontWeight: FontWeight.w500),
                          //             ),
                          //             Text(
                          //               tr('orders.domain.items.item1.description'),
                          //               style: GoogleFonts.roboto(
                          //                   fontSize: 13,
                          //                   //color: Color(#687787),
                          //                   color: ColorsApp.ContentTertiary,
                          //                   fontWeight: FontWeight.w400),
                          //             ),
                          //           ],
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          // Container(
                          //   height: 56,
                          //   width: double.infinity,
                          //   decoration: BoxDecoration(
                          //     border: Border(
                          //       top: BorderSide(
                          //         color: ColorsApp.ContentDivider,
                          //         width: 1.0,
                          //       ),
                          //       bottom: BorderSide(
                          //         color: ColorsApp.ContentDivider,
                          //         width: 1.0,
                          //       ),
                          //     ),
                          //   ),
                          //   child: Row(
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       Padding(
                          //         padding:
                          //             const EdgeInsets.only(left: 25.0, right: 17),
                          //         child: Icon(CupertinoIcons.flame),
                          //       ),
                          //       Expanded(
                          //         child: Column(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           crossAxisAlignment: CrossAxisAlignment.start,
                          //           children: [
                          //             Text(
                          //               tr('orders.domain.items.item2.title'),
                          //               style: GoogleFonts.roboto(
                          //                   fontSize: 15,
                          //                   //color: Color(#687787),
                          //                   color: ColorsApp.ContentPrimary,
                          //                   fontWeight: FontWeight.w500),
                          //             ),
                          //             Text(
                          //               tr('orders.domain.items.item2.description'),
                          //               style: GoogleFonts.roboto(
                          //                   fontSize: 13,
                          //                   //color: Color(#687787),
                          //                   color: ColorsApp.ContentTertiary,
                          //                   fontWeight: FontWeight.w400),
                          //             ),
                          //           ],
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          // Container(
                          //   height: 56,
                          //   width: double.infinity,
                          //   decoration: BoxDecoration(
                          //     border: Border(
                          //       top: BorderSide(
                          //         color: ColorsApp.ContentDivider,
                          //         width: 1.0,
                          //       ),
                          //       bottom: BorderSide(
                          //         color: ColorsApp.ContentDivider,
                          //         width: 1.0,
                          //       ),
                          //     ),
                          //   ),
                          //   child: Row(
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       Padding(
                          //         padding:
                          //             const EdgeInsets.only(left: 25.0, right: 17),
                          //         child: Icon(CupertinoIcons.ant),
                          //       ),
                          //       Expanded(
                          //         child: Column(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           crossAxisAlignment: CrossAxisAlignment.start,
                          //           children: [
                          //             Text(
                          //               tr('orders.domain.items.item3.title'),
                          //               style: GoogleFonts.roboto(
                          //                   fontSize: 15,
                          //                   //color: Color(#687787),
                          //                   color: ColorsApp.ContentPrimary,
                          //                   fontWeight: FontWeight.w500),
                          //             ),
                          //             Text(
                          //               tr('orders.domain.items.item3.description'),
                          //               style: GoogleFonts.roboto(
                          //                   fontSize: 13,
                          //                   //color: Color(#687787),
                          //                   color: ColorsApp.ContentTertiary,
                          //                   fontWeight: FontWeight.w400),
                          //             ),
                          //           ],
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.all(32.0),
                          //   child: Row(
                          //     children: [
                          //       Expanded(
                          //         child: Container(
                          //           height: 56,
                          //           width: 56,
                          //           child: MaterialButton(
                          //             onPressed: () {},
                          //             color: ColorsApp.BackgroundBrandSecondary,
                          //             textColor: Colors.white,
                          //             child: Icon(
                          //               CupertinoIcons.phone,
                          //               color: Color.fromRGBO(0, 125, 188, 1),
                          //             ),
                          //             shape: CircleBorder(),
                          //           ),
                          //         ),
                          //       ),
                          //       Expanded(
                          //         child: Container(
                          //           height: 56,
                          //           width: 56,
                          //           child: MaterialButton(
                          //             onPressed: () {},
                          //             color: ColorsApp.BackgroundBrandSecondary,
                          //             textColor: Colors.white,
                          //             child: Icon(
                          //               CupertinoIcons.text_bubble,
                          //               color: Color.fromRGBO(0, 125, 188, 1),
                          //             ),
                          //             shape: CircleBorder(),
                          //           ),
                          //         ),
                          //       ),
                          //       // Expanded(
                          //       //   child: Container(
                          //       //     height: 56,
                          //       //     width: 56,
                          //       //     child: MaterialButton(
                          //       //       onPressed: () {},
                          //       //       color: ColorsApp.BackgroundBrandSecondary,
                          //       //       textColor: Colors.white,
                          //       //       child: Icon(
                          //       //         CupertinoIcons.arrow_up_right_diamond,
                          //       //         color: Color.fromRGBO(0, 125, 188, 1),
                          //       //       ),
                          //       //       shape: CircleBorder(),
                          //       //     ),
                          //       //   ),
                          //       // ),
                          //     ],
                          //   ),
                          // )
                        ],
                      ),
                      // Align(
                      //   alignment: Alignment.bottomCenter,
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(bottom:70.0),
                      //     child: Container(
                      //       height: 100,
                      //       width: 100,
                      //       child: RiveAnimation.asset(
                      //         'assets/scroll.riv',
                      //         controllers: [_controller],
                      //         // Update the play state when the widget's initialized
                      //         onInit: (_) => setState(() {}),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      (state is CartLoadInProgress) ? Loading() : Container(),
                      (stateStations is StationsLoadInProgress)
                          ? Loading()
                          : Container(),
                    ],
                  ),
                ),
              ));
            },
          );
        },
      ),
    );
  }
}
