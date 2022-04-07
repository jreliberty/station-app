import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../blocs/cart/cart_bloc.dart';
import '../../../constants/colors.dart';
import '../../../entities/cart.dart';
import '../../../route_order/insurance/pages/page_insurance.dart';
import '../../../route_order/map/functions/geolocate.dart';
import '../../widgets/advantage_card.dart';
import '../pages/page_date_picker_fast_order.dart';
import '../pages/page_recherche_stations_fast_order.dart';
import '../pages/page_selection_pass.dart';
import 'avatar_view_fast_order.dart';

class FastOrderWidget extends StatefulWidget {
  final Cart cart;
  FastOrderWidget({Key? key, required this.cart}) : super(key: key);

  @override
  _FastOrderWidgetState createState() => _FastOrderWidgetState();
}

class _FastOrderWidgetState extends State<FastOrderWidget> {
  String stringDate = '';
  var formatter = new DateFormat('dd/MM/yyyy');
  int globalPrice = 0;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final aDate = DateTime(widget.cart.startDate.year,
        widget.cart.startDate.month, widget.cart.startDate.day);
    if (aDate == today) {
      stringDate = tr('common.today');
    } else if (aDate == tomorrow) {
      stringDate = tr('common.tomorrow');
    } else
      stringDate = 'Dans ${aDate.difference(today).inDays} jours';
    widget.cart.selectedContacts.forEach((element) {
      globalPrice += element.price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Notre suggestion pour toi',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                  height: 1.43,
                  fontSize: 14,
                  letterSpacing: -0.08,
                  //color: Color(#687787),
                  color: ColorsApp.ContentPrimaryReversed.withOpacity(0.6),
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              decoration: BoxDecoration(
                  color: ColorsApp.BackgroundPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16)),
              height: 60,
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 9),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: Text(
                                widget.cart.station.name,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.roboto(
                                    //color: Color(#687787),
                                    height: 1.2,
                                    fontSize: 20,
                                    color: ColorsApp.ContentPrimaryReversed,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 4,
                              ),
                              child: Text(
                                widget.cart.domain.label,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.roboto(
                                    //color: Color(#687787),
                                    height: 1.2,
                                    fontSize: 16,
                                    color: ColorsApp.ContentPrimaryReversed,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () async {
                        Position? position;
                        try {
                          if (Platform.isAndroid)
                            position = await determinePositionAndroid();
                          else
                            position = await determinePositionIos();
                        } catch (e) {
                          print(e);
                        }
                        await showCupertinoModalPopup(
                            context: context,
                            builder: (context) =>
                                PageRechercheStationsFastOrder(
                                  position: position,
                                  selectedContacts:
                                      widget.cart.selectedContacts,
                                  startDate: widget.cart.startDate,
                                ));
                      },
                      child: Container(
                        width: 50,
                        child: Icon(
                          FlutterRemix.edit_line,
                          color: Colors.white,
                          size: 27,
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  color: ColorsApp.BackgroundPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16)),
              height: 60,
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 9),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: Text(
                                stringDate,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.roboto(
                                    //color: Color(#687787),
                                    height: 1.2,
                                    fontSize: 20,
                                    color: ColorsApp.ContentPrimaryReversed,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 4,
                              ),
                              child: Text(
                                formatDate.format(widget.cart.startDate),
                                textAlign: TextAlign.start,
                                style: GoogleFonts.roboto(
                                    //color: Color(#687787),
                                    height: 1.2,
                                    fontSize: 16,
                                    color: ColorsApp.ContentPrimaryReversed,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () async {
                        await showCupertinoModalPopup(
                          context: context,
                          builder: (context) => PageDatePickerFastOrder(
                            domain: widget.cart.domain,
                            selectedContacts: widget.cart.selectedContacts,
                            startDate: widget.cart.startDate,
                            station: widget.cart.station,
                          ),
                        );
                      },
                      child: Container(
                        width: 50,
                        child: Icon(
                          FlutterRemix.edit_line,
                          color: Colors.white,
                          size: 27,
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 96,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: ColorsApp.BackgroundPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 64,
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(0),
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.cart.selectedContacts.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              SizedBox(
                                width: 16,
                              ),
                              AvatarViewFastOrder(
                                  initials:
                                      '${widget.cart.selectedContacts[index].firstName[0].toUpperCase()}${widget.cart.selectedContacts[index].lastName[0].toUpperCase()}'),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () async {
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                PageSelectionPassFastOrder()));
                      },
                      child: Container(
                        width: 50,
                        child: Icon(
                          FlutterRemix.edit_line,
                          color: Colors.white,
                          size: 27,
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: ColorsApp.BackgroundAccent),
                onPressed: () {
                  BlocProvider.of<CartBloc>(context).add(SetCartEvent(
                      cart: Cart(
                    station: widget.cart.station,
                    domain: widget.cart.domain,
                    startDate: widget.cart.startDate,
                    validity: widget.cart.validity,
                    contacts: widget.cart.contacts,
                    selectedContacts: widget.cart.selectedContacts,
                    selectedInsurances: widget.cart.selectedInsurances,
                    insurance: widget.cart.insurance,
                    promotions: widget.cart.promotions,
                  )));
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => PageInsurance()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FlutterRemix.shopping_cart_line,
                      color: Color.fromRGBO(0, 16, 21, 1),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          tr('orders.pass.buttons.button2.label', args: [
                            (globalPrice / 100) % 1 == 0
                                ? (globalPrice / 100).truncate().toString()
                                : (globalPrice / 100)
                                    .toStringAsFixed(2)
                                    .replaceAll('.', ',')
                          ]),
                          style: GoogleFonts.roboto(
                              fontSize: 15,
                              color: Color.fromRGBO(0, 16, 21, 1),
                              fontWeight: FontWeight.w700),
                        )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
