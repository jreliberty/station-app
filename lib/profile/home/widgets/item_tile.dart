import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';

class ItemTile extends StatefulWidget {
  final IconData? icon;
  final String label;
  final Widget page;
  ItemTile(
      {Key? key, required this.icon, required this.label, required this.page})
      : super(key: key);

  @override
  _ItemTileState createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => widget.page));
      },
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            /*top: BorderSide(
              color: ColorsApp.ContentDivider,
              width: 1.0,
            ),*/
            bottom: BorderSide(
              color: ColorsApp.ContentDivider,
              width: 1.0,
            ),
          ),
          color: ColorsApp.ContentPrimaryReversed,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25),
              child: Icon(
                widget.icon,
                color: ColorsApp.ContentActive,
              ),
            ),
            Text(
              widget.label,
              style: GoogleFonts.roboto(
                  height: 1.5,
                  fontSize: 16,
                  color: ColorsApp.ContentPrimary,
                  fontWeight: FontWeight.w700),
            ),
            Spacer(
              flex: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Icon(
                Icons.keyboard_arrow_right,
              ),
            )
          ],
        ),
      ),
    );
  }
}
