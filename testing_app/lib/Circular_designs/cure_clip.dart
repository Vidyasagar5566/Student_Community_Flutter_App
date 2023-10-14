import 'package:flutter/material.dart';

class profile_Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 2 * size.height / 3);
    Offset curvePoint = Offset(size.width / 2, size.height);
    Offset endPoint = Offset(size.width, 2 * size.height / 5);

    path.quadraticBezierTo(
        curvePoint.dx, curvePoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
