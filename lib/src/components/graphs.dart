import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:serenity/src/models/emotions_measure.dart';

class MeasuresGraph extends StatelessWidget {
  final Map<String, EmotionsMeasure> measures;
  const MeasuresGraph(
    this.measures, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GraphPainter(measures),
    );
  }
}

class GraphPainter extends CustomPainter {
  final Map<String, EmotionsMeasure> measures;

  GraphPainter(this.measures);

  /// This functions returns the Rounded rectangular shape that will define
  /// the clipped bounds for our canvas, to ensure that all the drawings stay inside
  /// this bounds. The radius is the only "hard coded" info in this code. Is
  /// alwayws 15 to be the same as the BasicCard radius.
  RRect pathToClip(Offset center, double height, double width, double radius) {
    return RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: width, height: height),
      Radius.circular(radius),
    );
  }

  ///Given bounds for x and Y (where minY < maxY i.e., minY is the top part
  ///of the boundary). Whe generate a Path that, using cubic and quadratic
  ///bezier curves, interpolates the points:
  /// ((xMax - xMin)*(0.2), y1), ((xMax - xMin)/2, y2), ((xMax - xMin)*(0.8), y3)
  /// This is assuming that maxY >= y1, y2, y3 >= minY
  Path bezierInterpolationOf3Points(minX, minY, maxX, maxY, y1, y2, y3, Y) {
    double x1 = (maxX - minX) * (0.2);
    double x2 = (maxX - minX) * (0.5);
    double x3 = (maxX - minX) * (0.8);

    Path interpolation = Path()
          // ..moveTo(minX, minY)
          // ..lineTo(maxX, minY)
          ..moveTo(minX, Y)
          ..lineTo(minX, y1)
          // ..addOval(Rect.fromCenter(
          //     center: Offset(x1, y1), width: 15, height: 15)) //punto y1
          // ..addOval(Rect.fromCenter(
          //     center: Offset(x2, y2), width: 15, height: 15)) // punto y2
          // ..addOval(
          //     Rect.fromCenter(center: Offset(x3, y3), width: 15, height: 15))
          // ..moveTo(minX, y1)
          ..quadraticBezierTo((x1 - minX) * .6, y1, x1, y1)
          ..cubicTo((x1 + x2) / 2, y1, (x1 + x2) / 2, y2, x2,
              y2) //Bezier cúbica de y1 a y2
          ..cubicTo((x2 + x3) / 2, y2, (x2 + x3) / 2, y3, x3, y3)
          ..cubicTo(x3 + (maxX - x3) * .7, y3, x3 + (maxX - x3) * .4, maxY,
              maxX, maxY)
          ..lineTo(maxX, Y)
        // ..quadraticBezierTo(x3 + (maxX - x3) * .4, y3, maxX, maxY)
        ;
    return interpolation;
  }

  double scaleValue(double value, double minY, double maxY) {
    const double maxPossibleValue = 10;
    final double scaleUnit = (maxY - minY) / maxPossibleValue;
    return maxY - (scaleUnit * value);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double x = size.width;
    final double y = size.height;

    RRect clippedPath = pathToClip(Offset(x / 2, y / 2), y - 2, x - 2, 15);
    canvas.clipRRect(clippedPath);

    double minY = y * (2 / 5);
    double maxY = y * (4 / 5);

    //Prev scaled measures
    double yEmotionPrev = scaleValue(measures['prev']!.emotion, minY, maxY);
    double yAnxietyPrev = scaleValue(measures['prev']!.anxiety, minY, maxY);
    double yStressPrev = scaleValue(measures['prev']!.stress, minY, maxY);
    //Pos scaled measures
    double yEmotionPos = scaleValue(measures['pos']!.emotion, minY, maxY);
    double yAnxietyPos = scaleValue(measures['pos']!.anxiety, minY, maxY);
    double yStressPos = scaleValue(measures['pos']!.stress, minY, maxY);

    Paint graphLineStroke = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white
      ..strokeWidth = y * .015;

    Paint secondaryLineStroke = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.lightBlueAccent
      ..strokeWidth = y * .015;

    Paint mainGraphFillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue
      ..shader = ui.Gradient.linear(
        Offset(x / 2, minY),
        Offset(x / 2, y),
        [
          Color(0xFFC12DC1),
          Color(0x728426F0),
          Color(0x23A7BBF1),
        ],
        [0.0, 0.5, 1],
      );

    Paint secondaryGraphFillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue
      ..shader = ui.Gradient.linear(
        Offset(x / 2, minY),
        Offset(x / 2, y),
        [
          Color(0xFF0F7FCF),
          Color(0x220478FF),
        ],
      );

    Path mainGraphLine = bezierInterpolationOf3Points(
        0.0, minY, x, maxY, yEmotionPos, yStressPos, yAnxietyPos, y);

    Path secondaryGraphLine = bezierInterpolationOf3Points(
        0.0, minY, x, maxY, yEmotionPrev, yStressPrev, yAnxietyPrev, y);`

    canvas.drawPath(secondaryGraphLine, secondaryLineStroke);
    canvas.drawPath(secondaryGraphLine, secondaryGraphFillPaint);
    canvas.drawPath(mainGraphLine, graphLineStroke);
    canvas.drawPath(mainGraphLine, mainGraphFillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
