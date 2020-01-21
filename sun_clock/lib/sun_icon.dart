import 'package:flutter/material.dart';
import 'dart:math';
import 'package:vector_math/vector_math_64.dart' show degrees2Radians;

class SunIconHand extends StatelessWidget {
  final double angleRadians;

  const SunIconHand({
    @required this.angleRadians
  }) : assert(angleRadians != null);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox.expand(
      child: ClipOval(
        clipper: CircleClipper(),
        child: Transform.rotate(
          angle: angleRadians * degrees2Radians + pi / 2,
          alignment: Alignment.center,
          child: Transform.translate(
              child: Center(
                child: Text(
                  '◉️',
                  style: TextStyle(
                      fontSize: 50,
                      color: Colors.orange,
                      fontWeight: FontWeight.w900,
                      height: 0.8),
                  textAlign: TextAlign.center,
                ),
              ),
              offset: Offset(-193, 7)),
        ),
      ),
    );
  }
}


class CircleClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: 193
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
