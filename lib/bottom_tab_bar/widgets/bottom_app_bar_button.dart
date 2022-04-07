import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomAppBarButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final int index;
  final TabController controller;

  BottomAppBarButton(
      {Key? key,
      required this.icon,
      required this.label,
      required this.color,
      required this.index,
      required this.controller})
      : super(key: key);

  @override
  _BottomAppBarButtonState createState() => _BottomAppBarButtonState();
}

class _BottomAppBarButtonState extends State<BottomAppBarButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: Expanded(
            child: IconButton(
                icon: Icon(widget.icon, color: widget.color),
                onPressed: () {
                  widget.controller.animateTo(widget.index);
                }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            widget.label,
            style: GoogleFonts.roboto(
                fontSize: 10,
                //color: Color(#687787),
                color: widget.color,
                fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}
