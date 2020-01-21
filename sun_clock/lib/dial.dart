import 'dart:math';

import 'package:flutter/material.dart';

class ClockDial extends StatelessWidget {
  final color;
  ClockDial({ @required this.color });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 5 / 3,
      child: CustomPaint(
        painter: DialPainter(color: color),
      )
    );
  }
}

class DialPainter extends CustomPainter {
  final hourTickMarkLength = 10.0;
  final minuteTickMarkLength = 5.0;

  final hourTickMarkWidth = 3.0;
  final minuteTickMarkWidth = 1.5;

  final Color color;
  final Paint tickPaint;

  DialPainter({@required double size, @required Color color }) : tickPaint = Paint(), color = Colors.black  {
    tickPaint.color = color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var tickMarkLength;
    final angle = 2 * pi / 60;

    final radius = min(size.height, size.width) / 2;

    // drawing
    canvas.translate(size.width/2, size.height/2);

    for (var i = 0; i < 60; i++) {

      // thick every 5 minutes
      tickMarkLength = i % 5 == 0
          ? hourTickMarkLength
          : minuteTickMarkLength;

      tickPaint.strokeWidth =
          i % 5 == 0
              ? hourTickMarkWidth
              : minuteTickMarkWidth;

      canvas.drawLine(
          Offset(0.0, -radius),
          Offset(0.0, -radius + tickMarkLength), tickPaint);

      canvas.rotate(angle);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

enum ClockText { roman, arabic }
