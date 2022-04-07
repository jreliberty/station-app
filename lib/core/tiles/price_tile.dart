import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';

class PriceTile extends StatefulWidget {
  final double price;
  PriceTile({Key? key, required this.price}) : super(key: key);

  @override
  _PriceTileState createState() => _PriceTileState();
}

class _PriceTileState extends State<PriceTile> {
  final key = new GlobalKey();
  bool show = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: ColorsApp.BackgroundAccent,
      ),
      alignment: Alignment.center,
      height: 32,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 8,
          ),
          Text(
            (widget.price % 1) == 0
                ? '${widget.price.truncate()} €'
                : '${widget.price.toStringAsFixed(2).replaceAll('.', ',')} €',
            style: GoogleFonts.roboto(
                fontSize: 15,
                height: 1,
                //color: Color(#687787),
                color: ColorsApp.ContentPrimary,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            width: 8,
          ),
          // Icon(
          //   FlutterRemix.information_line,
          //   size: 18,
          // ),
          // SizedBox(
          //   width: 4,
          // ),
        ],
      ),
    );
  }
}
