import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serenity/src/models/emotions_measure.dart';

class MeasuresGraph extends StatelessWidget {
  final Map<String, EmotionsMeasure> measures;
  const MeasuresGraph(
    this.measures, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth;
      double height = constraints.maxHeight;

      double labelWidth = width * .26;
      double labelHeight = labelWidth * .32;

      return CustomPaint(
        painter: GraphPainter(measures),
        child: Stack(
          children: [
            Positioned(
              top: height * .07,
              left: width * .12,
              child: Text(
                "Gráfico de la meditación.",
                style: GoogleFonts.raleway(
                    color: Color(0xFF768596),
                    fontWeight: FontWeight.w700,
                    fontSize: height * .07),
              ),
            ),
            Positioned(
              bottom: height * .08,
              left: width * .06,
              child: Text(
                "Duración de la práctica. 3 mins",
                style: GoogleFonts.raleway(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: height * .06),
              ),
            ),
            Positioned(
              top: height * (2 / 5) - labelHeight,
              left: width * .2 - labelWidth / 2,
              child: GraphLabel(
                child: Container(
                  //Ancho y largo específicos para ajustarlos al tamaño del path
                  width: labelWidth,
                  height: labelHeight,
                  color: Color(0xFF9574CD),
                  //Padding específico para que el child quede dentro de la burbuja
                  //Descrita por el Path
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(labelWidth * .05,
                        labelWidth * .05, labelWidth * .05, labelWidth * .13),
                    child: Center(
                      child: Text(
                        "Ánimo",
                        style: GoogleFonts.raleway(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: width * .025),
                      ),
                    ),
                  ),
                ),
                // width: ,
              ),
            ),
            Positioned(
              top: height * (2 / 5) - labelHeight,
              left: width * .5 - labelWidth / 2,
              child: GraphLabel(
                child: Container(
                  //Ancho y largo específicos para ajustarlos al tamaño del path
                  width: labelWidth,
                  height: labelHeight,
                  color: Color(0xFF9574CD),
                  //Padding específico para que el child quede dentro de la burbuja
                  //Descrita por el Path
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(labelWidth * .05,
                        labelWidth * .05, labelWidth * .05, labelWidth * .13),
                    child: Center(
                      child: Text(
                        "Estrés",
                        style: GoogleFonts.raleway(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: width * .025),
                      ),
                    ),
                  ),
                ),
                // width: ,
              ),
            ),
            Positioned(
              top: height * (2 / 5) - labelHeight,
              left: width * .8 - labelWidth / 2,
              child: GraphLabel(
                child: Container(
                  //Ancho y largo específicos para ajustarlos al tamaño del path
                  width: labelWidth,
                  height: labelHeight,
                  color: Color(0xFF9574CD),
                  //Padding específico para que el child quede dentro de la burbuja
                  //Descrita por el Path
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(labelWidth * .05,
                        labelWidth * .05, labelWidth * .05, labelWidth * .13),
                    child: Center(
                      child: Text(
                        "Ansiedad",
                        style: GoogleFonts.raleway(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: width * .025),
                      ),
                    ),
                  ),
                ),
                // width: ,
              ),
            ),
          ],
        ),
      );
    });
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

    Paint labelFillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.lightBlue;

    Path mainGraphLine = bezierInterpolationOf3Points(
        0.0, minY, x, maxY, yEmotionPos, yStressPos, yAnxietyPos, y);

    Path secondaryGraphLine = bezierInterpolationOf3Points(
        0.0, minY, x, maxY, yEmotionPrev, yStressPrev, yAnxietyPrev, y);

    canvas.drawPath(secondaryGraphLine, secondaryLineStroke);
    canvas.drawPath(secondaryGraphLine, secondaryGraphFillPaint);
    canvas.drawPath(mainGraphLine, graphLineStroke);
    canvas.drawPath(mainGraphLine, mainGraphFillPaint);

    Path emotionLabel = graphLabelPath(x * 0.26, Offset(x * 0.2, minY));
    Path anxietyLabel = graphLabelPath(x * 0.26, Offset(x * 0.5, minY));
    Path stressLabel = graphLabelPath(x * 0.26, Offset(x * 0.8, minY));
    // canvas.drawPath(emotionLabel, labelFillPaint);
    // canvas.drawPath(anxietyLabel, labelFillPaint);
    // canvas.drawPath(stressLabel, labelFillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

Path graphLabelPath(double width, Offset arrowTip) {
  double x = arrowTip.dx;
  double y = arrowTip.dy;
  double height = width * .2;
  double arrowTipLength = width * .12;
  double arrowTipSideOffset = arrowTipLength / sqrt(2);
  double sideRadius = width * .07;

  double rightBorderSideDx = x + (width / 2) - sideRadius;
  double leftBorderSideDx = x - ((width / 2)) + sideRadius;

  return Path()
    ..moveTo(x, y)
    ..lineTo(x + arrowTipSideOffset, y - arrowTipSideOffset)
    ..lineTo(rightBorderSideDx, y - arrowTipSideOffset)
    ..cubicTo(
        rightBorderSideDx + sideRadius * 1.33,
        y - arrowTipSideOffset,
        rightBorderSideDx + sideRadius * 1.33,
        y - height - arrowTipSideOffset,
        rightBorderSideDx,
        y - arrowTipSideOffset - height)
    ..lineTo(leftBorderSideDx, y - arrowTipSideOffset - height)
    ..cubicTo(
        leftBorderSideDx - sideRadius * 1.33,
        y - height - arrowTipSideOffset,
        leftBorderSideDx - sideRadius * 1.33,
        y - arrowTipSideOffset,
        leftBorderSideDx,
        y - arrowTipSideOffset)
    ..lineTo(x - arrowTipSideOffset, y - arrowTipSideOffset)
    ..close();
}

class GraphLabelClipper extends CustomClipper<Path> {
  @override
  ui.Path getClip(ui.Size size) {
    return graphLabelPath(size.width, Offset(size.width / 2, size.height));
  }

  @override
  bool shouldReclip(covariant CustomClipper<ui.Path> oldClipper) {
    return true;
  }
}

class GraphLabel extends StatelessWidget {
  // double width;
  Widget child;
  GraphLabel({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(clipper: GraphLabelClipper(), child: child);
  }
}
