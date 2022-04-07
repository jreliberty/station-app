import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';
import '../../../entities/contact.dart';
import '../../../entities/station_tile_data.dart';
import '../pages/page_domaines_fast_order.dart';

class StationTileFastOrder extends StatelessWidget {
  final StationTileData stationData;
  final DateTime startDate;
  final List<Contact> selectedContacts;
  const StationTileFastOrder({
    Key? key,
    required this.stationData,
    required this.startDate,
    required this.selectedContacts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => PageDomainesFastOrder(
                    selectedContacts: selectedContacts,
                    station: stationData.station,
                    startDate: startDate,
                  )));
        },
        title: Text(
          stationData.station.name,
          style: GoogleFonts.roboto(
              fontSize: 16,
              //color: Color(#687787),
              color: ColorsApp.ContentPrimary,
              fontWeight: FontWeight.w700),
        ),
        subtitle: (stationData.distance != null)
            ? Text(
                stationData.distance!.truncate().toString() + ' km',
                style: GoogleFonts.roboto(
                    fontSize: 14,
                    //color: Color(#687787),
                    color: ColorsApp.ContentTertiary,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.08),
              )
            : Text(
                '',
                style: GoogleFonts.roboto(
                    fontSize: 14,
                    //color: Color(#687787),
                    color: ColorsApp.ContentTertiary,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.08),
              ),
        contentPadding: EdgeInsets.all(0),
        leading: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            // fixed width and height
            child: (stationData.station.domains.isEmpty)
                ? Image.network(
                    'assets/lesArcs.jpg',
                    fit: BoxFit.cover,
                    height: 60.0,
                    width: 60.0,
                  )
                : Image.network(
                    stationData.station.domains[0].pictureUrl,
                    fit: BoxFit.cover,
                    height: 60.0,
                    width: 60.0,
                  )));
  }
}
