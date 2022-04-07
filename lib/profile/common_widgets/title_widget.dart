import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';

class TitleWidget extends StatelessWidget {
  final String label;
  const TitleWidget({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(FlutterRemix.arrow_left_line),
            color: ColorsApp.ContentPrimary,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              label,
              style: GoogleFonts.roboto(
                  height: 1.2,
                  fontSize: 20,
                  color: ColorsApp.ContentPrimary,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
