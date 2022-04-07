import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';
import '../clippers/triangle_clipper.dart';

class TooltipPriceStation extends StatefulWidget {
  TooltipPriceStation({Key? key}) : super(key: key);

  @override
  _TooltipPriceStationState createState() => _TooltipPriceStationState();
}

class _TooltipPriceStationState extends State<TooltipPriceStation> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: ClipPath(
            clipper: TriangleClipper(),
            child: Container(
              height: 7,
              width: 12,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(4),
          ),
          height: 36,
          width: 267,
          child: Center(
            child: Text(
              'Sur la base d’un adulte en haute saison',
              style: GoogleFonts.roboto(
                  height: 1.2,
                  fontSize: 14,
                          color: ColorsApp.ContentPrimaryReversed,
                  fontWeight: FontWeight.w400),
            ),
          ),
        )
      ],
    );
  }
}
