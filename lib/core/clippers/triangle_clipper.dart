import 'package:flutter/material.dart';

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path0 = Path();
    path0.moveTo(0, size.height);
    path0.lineTo(size.width, size.height);
    path0.lineTo(size.width * 0.5000000, 0);
    path0.lineTo(0, size.height);
    return path0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
