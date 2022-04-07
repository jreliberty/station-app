import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../blocs/datepicker/datepicker_bloc.dart';
import '../../../blocs/favorite_station/favorite_station_bloc.dart';
import '../../../constants/colors.dart';
import '../../../entities/station.dart';
import 'tooltip_price_tile.dart';

class StationCard extends StatefulWidget {
  final DateTime? date;
  final Station? station;
  StationCard({Key? key, required this.station, required this.date})
      : super(key: key);

  @override
  _StationCardState createState() => _StationCardState();
}

class _StationCardState extends State<StationCard> {
  final key = new GlobalKey();
  double height = 280;

  Offset _tapPosition = Offset(0, 0);
  bool _toolTipVisible = false;
  double bottomPosition = 96;

  @override
  void initState() {
    if (widget.station!.domains.length > 0)
      height = 280 + (widget.station!.domains.length - 1) * 48;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.station!.domains.length > 0)
      height = 200 + (widget.station!.domains.length - 1) * 48;
    bool isFavorite = false;

    return Container(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(0),
      height: (widget.station!.activeSales) ? height : 160,
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
          ),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 24.0,
            right: 24,
            left: 24,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 32,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.station!.name,
                        style: GoogleFonts.roboto(
                            fontSize: 28,
                            //color: Color(#687787),
                            color: ColorsApp.ContentPrimary,
                            fontWeight: FontWeight.w700),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!isFavorite)
                          BlocProvider.of<FavoriteStationBloc>(context).add(
                              UpdateFavoriteStationEvent(
                                  contractorId: widget.station!.contractorId));
                        else
                          BlocProvider.of<FavoriteStationBloc>(context)
                              .add(UpdateFavoriteStationEvent(contractorId: 0));
                      },
                      child: BlocBuilder<FavoriteStationBloc,
                          FavoriteStationState>(
                        builder: (context, state) {
                          if (state is FavoriteStationLoadSuccess &&
                              state.contractorId ==
                                  widget.station!.contractorId &&
                              state.contractorId != 0) {
                            isFavorite = true;
                            return Icon(
                              FlutterRemix.heart_3_fill,
                              size: 35,
                              color: Colors.black,
                            );
                          } else {
                            isFavorite = false;
                            return Icon(
                              FlutterRemix.heart_3_line,
                              size: 35,
                              color: Colors.black,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              (widget.station!.domains.isNotEmpty &&
                      widget.station!.activeSales)
                  ? ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 0, right: 0),
                      itemCount: widget.station!.domains.length,
                      itemBuilder: (context, index) {
                        return TooltipPriceTile(
                            domain: widget.station!.domains[index]);
                      },
                    )
                  // Column(
                  //     children: widget.station!.domains.map((e) {
                  //       print(e);
                  //       return Container(color: Colors.red, child: TooltipPriceTile(domain: e));
                  //     }).toList(),
                  //   )
                  : Container(),
              (true == false)
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                widget.station!.weatherData != null
                                    ? Icon(
                                        FlutterRemix.temp_cold_line,
                                        size: 22,
                                        color: Color.fromRGBO(0, 125, 188, 1),
                                      )
                                    : Container(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    widget.station!.weatherData == null
                                        ? ''
                                        : '${widget.station!.weatherData!.tempMin}ºC / ${widget.station!.weatherData!.tempMax}ºC',
                                    style: GoogleFonts.roboto(
                                        fontSize: 15,
                                        //color: Color(#687787),
                                        color: Color.fromRGBO(104, 119, 135, 1),
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              widget.station!.weatherData != null
                                  ? Icon(
                                      FlutterRemix.snowy_line,
                                      size: 22,
                                      color: Color.fromRGBO(0, 125, 188, 1),
                                    )
                                  : Container(),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  widget.station!.weatherData == null
                                      ? ''
                                      : tr('orders.map.labels.snow', args: [
                                          widget
                                              .station!.weatherData!.snowHeight
                                              .toString()
                                        ]),
                                  style: GoogleFonts.roboto(
                                      fontSize: 15,
                                      //color: Color(#687787),
                                      color: ColorsApp.ContentTertiary,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(0, 125, 188, 1)),
                      onPressed: () async {
                        if (widget.date != null)
                          BlocProvider.of<DatepickerBloc>(context)
                              .add(DatepickerNotRequestedEvent());
                        // Navigator.of(context).pushReplacement(MaterialPageRoute(
                        //     builder: (BuildContext context) => PageDomaines(
                        //         domains: widget.station!.domains,
                        //         station: widget.station!, startDate: widget.date,)));
                        else {
                          BlocProvider.of<DatepickerBloc>(context)
                              .add(DatepickerRequestedEvent());
                        }
                      },
                      child: Text(
                        tr('orders.map.buttons.button2.label'),
                        style: GoogleFonts.roboto(
                            fontSize: 15,
                            //color: Color(#687787),
                            color: ColorsApp.ContentPrimaryReversed,
                            fontWeight: FontWeight.w700),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
