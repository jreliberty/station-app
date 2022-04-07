import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';
import '../../../entities/adress.dart';

class CardTile extends StatefulWidget {
  final Address adress;
  CardTile({Key? key, required this.adress}) : super(key: key);

  @override
  _CardTileState createState() => _CardTileState();
}

class _CardTileState extends State<CardTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          /*top: BorderSide(
              color: Color.fromRGBO(230, 230, 230, 1),
              width: 1.0,
            ),*/
          bottom: BorderSide(
            color: Color.fromRGBO(230, 230, 230, 1),
            width: 1.0,
          ),
        ),
      ),
      height: 80,
      child: Row(
        children: [
          SizedBox(
            width: 64,
            child: Icon(
              CupertinoIcons.house,
              color: Color.fromRGBO(0, 125, 188, 1),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'France',
                style: GoogleFonts.roboto(
                    height: 1.5,
                    fontSize: 16,
                    color: ColorsApp.ContentPrimary,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                widget.adress.city,
                style: GoogleFonts.roboto(
                    height: 1.43,
                    fontSize: 14,
                    color: ColorsApp.ContentTertiary,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                widget.adress.street,
                style: GoogleFonts.roboto(
                    height: 1.43,
                    fontSize: 14,
                    color: ColorsApp.ContentTertiary,
                    fontWeight: FontWeight.w400),
              )
            ],
          )
        ],
      ),
    );
  }
}
