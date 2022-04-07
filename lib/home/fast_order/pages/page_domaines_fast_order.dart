import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../blocs/fast_cart/fast_cart_bloc.dart';
import '../../../constants/colors.dart';
import '../../../core/utils/loading.dart';
import '../../../entities/contact.dart';
import '../../../entities/station.dart';
import '../widgets/domain_card_fast_order.dart';

class PageDomainesFastOrder extends StatefulWidget {
  final Station station;
  final DateTime startDate;
  final List<Contact> selectedContacts;
  PageDomainesFastOrder(
      {Key? key,
      required this.station,
      required this.startDate,
      required this.selectedContacts})
      : super(key: key);

  @override
  _PageDomainesFastOrderState createState() => _PageDomainesFastOrderState();
}

class _PageDomainesFastOrderState extends State<PageDomainesFastOrder> {
  // Toggles between play and pause animation states

  /// Tracks if the animation is playing by whether controller is running

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FastCartBloc, FastCartState>(
      listener: (context, state) async {
        if (state is FastCartLoadSuccess) {
          int count = 0;
          Navigator.of(context).popUntil((_) => count++ == 2);
        }
      },
      child: BlocBuilder<FastCartBloc, FastCartState>(
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
                              Navigator.of(context).pop(false);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 24,
                        ),
                        child: Text(
                          widget.station.name,
                          style: GoogleFonts.roboto(
                              height: 1.11,
                              fontSize: 36,
                              //color: Color(#687787),
                              color: ColorsApp.ContentPrimary,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      (widget.station.domains.length > 1)
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
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.station.domains
                                  .map((e) => DomainCard(
                                        domain: e,
                                        station: widget.station,
                                        startDate: widget.startDate,
                                        selectedContacts:
                                            widget.selectedContacts,
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 24,
                      )
                    ],
                  ),
                  (state is FastCartLoadInProgress) ? Loading() : Container(),
                ],
              ),
            ),
          ));
        },
      ),
    );
  }
}
