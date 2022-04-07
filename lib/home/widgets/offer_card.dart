import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../blocs/stations/stations_bloc.dart';
import '../../constants/colors.dart';
import '../../core/tiles/price_tile.dart';
import '../../entities/offer.dart';
import '../../entities/station.dart';
import '../../route_order/domain/pages/page_domaines.dart';
import '../pages/page_date_picker.dart';

var formatDate = new DateFormat("d MMM yyyy", 'fr');
var formatDateNoYear = new DateFormat("d MMM", 'fr');

class OfferCard extends StatefulWidget {
  final List<Station> listStations;
  final Offer offer;
  const OfferCard({Key? key, required this.offer, required this.listStations})
      : super(key: key);

  @override
  State<OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
  late String finalPriceString;
  late String initialPriceString;
  late String differencePriceString;
  @override
  void initState() {
    super.initState();
    finalPriceString =
        '${(widget.offer.promoPrice / 100) % 1 == 0 ? (widget.offer.promoPrice / 100).truncate() : (widget.offer.promoPrice / 100).toStringAsFixed(2).replaceAll('.', ',')} €';
    initialPriceString =
        '${(widget.offer.fromPrice / 100) % 1 == 0 ? (widget.offer.fromPrice / 100).truncate() : (widget.offer.fromPrice / 100).toStringAsFixed(2).replaceAll('.', ',')}€';

    differencePriceString =
        '-${(((widget.offer.fromPrice - widget.offer.promoPrice) / widget.offer.fromPrice) * 100).round()}% avec le Pass';
    print(((widget.offer.fromPrice - widget.offer.promoPrice) /
            widget.offer.fromPrice) *
        100);
  }

  String getLabelDates() {
    if ((widget.offer.dateFrom.month == widget.offer.dateTo.month) &&
        (widget.offer.dateFrom.year == widget.offer.dateTo.year))
      return 'Du ${widget.offer.dateFrom.day} au ${formatDate.format(widget.offer.dateTo)}';
    else if (widget.offer.dateFrom.year == widget.offer.dateTo.year)
      return 'Du ${formatDateNoYear.format(widget.offer.dateFrom)} au ${formatDate.format(widget.offer.dateTo)}';
    else
      return 'Du ${formatDate.format(widget.offer.dateFrom)} au ${formatDate.format(widget.offer.dateTo)}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: GestureDetector(
        onTap: () async {
          DateTime date;
          print((widget.offer.dateFrom.isBefore(DateTime.now()) ||
              widget.offer.dateFrom.isAtSameMomentAs(DateTime.now())));
          print(widget.offer.dateTo);
          print((widget.offer.dateTo.isAfter(DateTime.now()) ||
              widget.offer.dateFrom.isAtSameMomentAs(DateTime.now())));
          if ((widget.offer.dateFrom.isBefore(DateTime.now()) ||
                  widget.offer.dateFrom.isAtSameMomentAs(DateTime.now())) &&
              (widget.offer.dateTo.isAfter(DateTime.now()) ||
                  widget.offer.dateFrom.isAtSameMomentAs(DateTime.now())))
            date = DateTime.now();
          else
            date = widget.offer.dateFrom;
          print(date);
          var tempDate = await showCupertinoModalPopup(
            context: context,
            builder: (context) => PageDatePicker(
              date: date,
              startDate: date,
              endDate: widget.offer.dateTo,
            ),
          );
          if (tempDate != null) {
            Station? station;
            widget.listStations.forEach((element) {
              if (element.contractorId == widget.offer.station.contractorId)
                station = element;
            });
            BlocProvider.of<StationsBloc>(context).add(ResetStationEvent(
              date: tempDate,
              selectedStation: station!,
            ));

            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => PageDomaines(
                      station: station!,
                      startDate: tempDate,
                    )));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 5,
            shadowColor: Color.fromRGBO(0, 83, 125, 0.15),
            child: Container(
              height: 400,
              width: 242,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: widget.offer.image),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(widget.offer.title,
                          style: TextStyle(
                              height: 1.5,
                              color: ColorsApp.ContentPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(widget.offer.description,
                          style: TextStyle(
                              height: 1.3,
                              color: ColorsApp.ContentPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w400)),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(getLabelDates(),
                          style: TextStyle(
                              height: 1.33,
                              color: ColorsApp.ContentTertiary,
                              fontSize: 12,
                              fontWeight: FontWeight.w400)),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        PriceTile(price: widget.offer.promoPrice / 100),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            initialPriceString,
                            style: GoogleFonts.roboto(
                                decoration: TextDecoration.lineThrough,
                                decorationThickness: 1,
                                letterSpacing: -0.08,
                                fontSize: 14,
                                //color: Color(#687787),
                                color: ColorsApp.ContentPrimary,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            differencePriceString,
                            style: GoogleFonts.roboto(
                                letterSpacing: -0.08,
                                fontSize: 14,
                                //color: Color(#687787),
                                color: Color.fromRGBO(227, 38, 47, 1),
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
