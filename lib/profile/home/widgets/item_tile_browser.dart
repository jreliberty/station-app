import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors.dart';
import 'browser_webview.dart';

class ItemTileBrowser extends StatefulWidget {
  final IconData? icon;
  final String label;
  final String url;
  ItemTileBrowser(
      {Key? key, required this.icon, required this.label, required this.url})
      : super(key: key);

  @override
  _ItemTileBrowserState createState() => _ItemTileBrowserState();
}

class _ItemTileBrowserState extends State<ItemTileBrowser> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await showCupertinoModalPopup(
            context: context,
            builder: (context) => BrowserWebview(
                  url: widget.url,
                ));
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
