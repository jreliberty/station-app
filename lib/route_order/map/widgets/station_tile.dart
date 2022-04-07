import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';
import '../../../entities/station_tile_data.dart';

class StationTile extends StatelessWidget {
  final StationTileData stationData;
  const StationTile({
    Key? key,
    required this.stationData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () => Navigator.of(context).pop(stationData.station),
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
                ? Image.asset(
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
