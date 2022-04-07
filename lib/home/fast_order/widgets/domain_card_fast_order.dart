import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../blocs/config/config_bloc.dart';
import '../../../blocs/consumer/consumer_bloc.dart';
import '../../../blocs/fast_cart/fast_cart_bloc.dart';
import '../../../constants/colors.dart';
import '../../../core/tiles/tooltip_price_domain.dart';
import '../../../entities/config.dart';
import '../../../entities/contact.dart';
import '../../../entities/domain.dart';
import '../../../entities/station.dart';
import '../../../route_order/domain/widgets/tooltip_price_tile.dart';

class DomainCard extends StatefulWidget {
  final DateTime startDate;
  final Domain domain;
  final Station station;
  final List<Contact> selectedContacts;
  DomainCard(
      {Key? key,
      required this.domain,
      required this.station,
      required this.startDate,
      required this.selectedContacts})
      : super(key: key);

  @override
  _DomainCardState createState() => _DomainCardState();
}

class _DomainCardState extends State<DomainCard> {
  late Config config;
  bool show = false;
  _toggle() {
    setState(() {
      show = !show;
    });
  }

  bool _toolTipVisible = false;
  double bottomPosition = 238;

  void _storePosition(TapDownDetails details) {
    _toolTipVisible = true;
    setState(() {});
  }

  @override
  void initState() {
    if (BlocProvider.of<ConfigBloc>(context).state is ConfigLoadSuccess)
      config = (BlocProvider.of<ConfigBloc>(context).state as ConfigLoadSuccess)
          .config;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _toolTipVisible = false;
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 12.0,
          bottom: 24,
          top: 0,
        ),
        child: Container(
          child: Stack(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 10,
                shadowColor: Color.fromRGBO(1, 83, 125, 0.15),
                child: Container(
                  //height: 657,
                  width: 302,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.domain.label,
                            style: TextStyle(
                                color: ColorsApp.ContentPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w700)),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              widget.domain.pictureUrl,
                              fit: BoxFit.cover,
                              height: 120,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ),
                        (config.activeSales && widget.station.activeSales)
                            ? GestureDetector(
                                onTapDown: _storePosition,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      TooltipPriceTile(domain: widget.domain),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 16,
                              ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(widget.domain.baseLine,
                              style: TextStyle(
                                  height: 1.3,
                                  color: ColorsApp.ContentPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700)),
                        ),
                        (widget.domain.bottomLine != '')
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Container(
                                  height: 78,
                                  decoration: BoxDecoration(
                                      color: ColorsApp.BackgroundBrandSecondary,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            FlutterRemix.alert_line,
                                            color:
                                                Color.fromRGBO(0, 125, 188, 1),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                            child: Text(
                                              widget.domain.bottomLine,
                                              style: GoogleFonts.roboto(
                                                  height: 1.43,
                                                  fontSize: 14,
                                                  //color: Color(#687787),
                                                  color: Color.fromRGBO(
                                                      0, 16, 24, 1),
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        GestureDetector(
                          onTap: _toggle,
                          child: Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "En savoir plus",
                                  style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      decoration: TextDecoration.underline,
                                      //color: Color(#687787),
                                      color: ColorsApp.ContentPrimary,
                                      fontWeight: FontWeight.w700),
                                ),
                                show
                                    ? Icon(FlutterRemix.arrow_down_s_line)
                                    : Icon(FlutterRemix.arrow_right_s_line),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 8,
                        ),

                        AnimatedSwitcher(
                          switchInCurve: Curves.easeIn,
                          switchOutCurve: Curves.easeOut,
                          duration: const Duration(milliseconds: 300),
                          reverseDuration: const Duration(milliseconds: 300),
                          child: show
                              ? Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16),
                                      child: Text(
                                        widget.domain.description,
                                        style: GoogleFonts.roboto(
                                            height: 1.43,
                                            letterSpacing: -0.08,
                                            fontSize: 14,
                                            //color: Color(#687787),
                                            color: ColorsApp.ContentPrimary,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(
                                  key: Key("hide"),
                                ),
                        ),

                        // Spacer(),
                        (widget.station.weatherData != null &&
                                (config.activeSales &&
                                    widget.station.activeSales))
                            ? Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FlutterRemix.route_line,
                                        size: 22,
                                        color: Color.fromRGBO(0, 125, 188, 1),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          ((widget.domain.areaSize % 1) == 0)
                                              ? '${widget.domain.areaSize.truncate()} km de pistes'
                                              : '${widget.domain.areaSize.toStringAsFixed(1).replaceAll('.', ',')} km de pistes',
                                          style: GoogleFonts.roboto(
                                              fontSize: 15,
                                              //color: Color(#687787),
                                              color: Color.fromRGBO(
                                                  104, 119, 135, 1),
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        //Icons.code,
                                        //Icons.open_in_full,
                                        CupertinoIcons.resize_h,
                                        size: 22,
                                        color: Color.fromRGBO(0, 125, 188, 1),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          '${widget.station.weatherData!.openSlopes}/${widget.station.weatherData!.totalSlopes} pistes',
                                          style: GoogleFonts.roboto(
                                              fontSize: 15,
                                              //color: Color(#687787),
                                              color: Color.fromRGBO(
                                                  104, 119, 135, 1),
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.import_export,
                                        size: 22,
                                        color: Color.fromRGBO(0, 125, 188, 1),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          '${widget.station.weatherData!.openLifts}/${widget.station.weatherData!.totalLifts} remontées',
                                          style: GoogleFonts.roboto(
                                              fontSize: 15,
                                              //color: Color(#687787),
                                              color: Color.fromRGBO(
                                                  104, 119, 135, 1),
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Container(),
                        //(!config.activeSales || !widget.station.activeSales)
                        (widget.station.weatherData == null)
                            ? Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FlutterRemix.route_line,
                                        size: 22,
                                        color: Color.fromRGBO(0, 125, 188, 1),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          ((widget.domain.areaSize % 1) == 0)
                                              ? '${widget.domain.areaSize.truncate()} km de pistes'
                                              : '${widget.domain.areaSize.toStringAsFixed(1).replaceAll('.', ',')} km de pistes',
                                          style: GoogleFonts.roboto(
                                              fontSize: 15,
                                              //color: Color(#687787),
                                              color: Color.fromRGBO(
                                                  104, 119, 135, 1),
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        //Icons.code,
                                        //Icons.open_in_full,
                                        CupertinoIcons.resize_h,
                                        size: 22,
                                        color: Color.fromRGBO(0, 125, 188, 1),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          '${widget.domain.slopesQuantity} pistes',
                                          style: GoogleFonts.roboto(
                                              fontSize: 15,
                                              //color: Color(#687787),
                                              color: Color.fromRGBO(
                                                  104, 119, 135, 1),
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.import_export,
                                        size: 22,
                                        color: Color.fromRGBO(0, 125, 188, 1),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          '${widget.domain.liftsQuantity} remontées',
                                          style: GoogleFonts.roboto(
                                              fontSize: 15,
                                              //color: Color(#687787),
                                              color: Color.fromRGBO(
                                                  104, 119, 135, 1),
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                ],
                              )
                            : Container(),
                        // Divider(
                        //   color: ColorsApp.ContentDivider,
                        //   thickness: 1,
                        // ),
                        (config.activeSales && widget.station.activeSales)
                            ? BlocBuilder<ConsumerBloc, ConsumerState>(
                                builder: (context, state) {
                                  if (state is ConsumerLoadSuccess)
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Container(
                                        width: double.infinity,
                                        height: 48,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Color.fromRGBO(
                                                    0, 125, 188, 1)),
                                            onPressed: () async {
                                              var formatter =
                                                  new DateFormat('yyyy-MM-dd');
                                              if (state
                                                  .user.contacts.isNotEmpty) {
                                                BlocProvider.of<FastCartBloc>(
                                                        context)
                                                    .add(GetFirstSimulationFastCartEvent(
                                                        user: state.user,
                                                        domain: widget.domain,
                                                        station: widget.station,
                                                        startDate: formatter
                                                            .format(widget
                                                                .startDate),
                                                        selectedContacts: widget
                                                            .selectedContacts));
                                              }
                                            },
                                            child: Text(
                                              tr('orders.domain.buttons.button1.label'),
                                              style: GoogleFonts.roboto(
                                                  fontSize: 15,
                                                  //color: Color(#687787),
                                                  color: ColorsApp.ContentPrimaryReversed,
                                                  fontWeight: FontWeight.w700),
                                            )),
                                      ),
                                    );
                                  else
                                    return Container();
                                },
                              )
                            : Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Container(
                                      width: double.infinity,
                                      height: 48,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: ColorsApp
                                                .BackgroundBrandInactive,
                                          ),
                                          onPressed: null,
                                          child: Text(
                                            tr('orders.domain.buttons.button1.label'),
                                            style: GoogleFonts.roboto(
                                                fontSize: 15,
                                                //color: Color(#687787),
                                                color: ColorsApp.ContentPrimaryReversed,
                                                fontWeight: FontWeight.w700),
                                          )),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "Les ventes sont désactivées pour le moment",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        //color: Color(#687787),
                                        color: ColorsApp.ContentTertiary,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: bottomPosition,
                  left: 30,
                  child: Opacity(
                    opacity: _toolTipVisible ? 1 : 0,
                    child: TooltipPriceDomain(),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
