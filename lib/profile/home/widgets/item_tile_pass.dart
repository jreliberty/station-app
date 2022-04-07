import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';
import '../../../entities/user.dart';

class ItemTilePass extends StatefulWidget {
  final User user;
  final IconData? icon;
  final String label;
  final Widget page;
  ItemTilePass(
      {Key? key,
      required this.icon,
      required this.label,
      required this.page,
      required this.user})
      : super(key: key);

  @override
  _ItemTilePassState createState() => _ItemTilePassState();
}

class _ItemTilePassState extends State<ItemTilePass> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (widget.user.firstName == '' ||
            widget.user.lastName == '' ||
            widget.user.birthDate == null) {
          await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return new AlertDialog(
                title: Text(tr('common.careful')),
                content: Text(
                    'Tu dois d\'abbord compléter tes informations personnelles !'),
                actions: <Widget>[
                  new TextButton(
                    child: Text('J\'ai compris'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            },
          );
        } else
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => widget.page));
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
