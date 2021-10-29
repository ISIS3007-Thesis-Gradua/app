import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:serenity/src/components/cards.dart';
import 'package:serenity/src/components/collapsed_container.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:stacked_services/stacked_services.dart';

class GraphView extends StatefulWidget {
  const GraphView({Key? key}) : super(key: key);

  @override
  _GraphViewState createState() => _GraphViewState();
}

class _GraphViewState extends State<GraphView> {
  GetIt locator = GetIt.instance;
  final _controller = PanelController();
  late final NavigationService navigationService;

  @override
  void initState() {
    navigationService = locator<NavigationService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double getHeight() {
      return MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom;
    }

    final double height = getHeight();
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F9FF),
        body: SlidingUpPanel(
          backdropOpacity: 0.17,
          controller: _controller,
          isDraggable: false,
          maxHeight: height * 0.67,
          minHeight: height * 0.06,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          collapsed: CollapsedContainer(_controller, height, width),
          panel: Text(""),
          body: Padding(
            padding: EdgeInsets.fromLTRB(0, height * .02, 0, height * .1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BasicCard(
                  height: height * .25,
                  width: width * .9,
                  child: Graph(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Graph extends StatelessWidget {
  const Graph({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GraphPainter(),
    );
  }
}

class GraphPainter extends CustomPainter {
  final double emotion = 2;
  final double stress = 7;
  final double anxiety = 5;

  ///Given bounds for x and Y (where minY < maxY i.e., minY is the top part
  ///of the boundary). Whe generate a Path that, using cubic and quadratic
  ///bezier curves, interpolates the points:
  /// ((xMax - xMin)*(0.2), y1), ((xMax - xMin)/2, y2), ((xMax - xMin)*(0.8), y3)
  /// This is assuming that maxY >= y1, y2, y3 >= minY
  Path bezierInterpolationOf3Points(minX, minY, maxX, maxY, y1, y2, y3) {
    double x1 = (maxX - minX) * (0.2);
    double x2 = (maxX - minX) * (0.5);
    double x3 = (maxX - minX) * (0.8);

    Path interpolation = Path()
          ..moveTo(minX, minY)
          ..lineTo(maxX, minY)
          ..moveTo(minX, maxY)
          ..lineTo(maxX, maxY)
          ..addOval(Rect.fromCenter(
              center: Offset(x1, y1), width: 15, height: 15)) //punto y1
          ..addOval(Rect.fromCenter(
              center: Offset(x2, y2), width: 15, height: 15)) // punto y2
          ..addOval(
              Rect.fromCenter(center: Offset(x3, y3), width: 15, height: 15))
          ..moveTo(minX, y1)
          ..quadraticBezierTo((x1 - minX) * .6, y1, x1, y1)
          ..cubicTo((x1 + x2) / 2, y1, (x1 + x2) / 2, y2, x2,
              y2) //Bezier cúbica de y1 a y2
          ..cubicTo((x2 + x3) / 2, y2, (x2 + x3) / 2, y3, x3, y3)
          ..cubicTo(x3 + (maxX - x3) * .7, y3, x3 + (maxX - x3) * .4, maxY,
              maxX, maxY)
        // ..quadraticBezierTo(x3 + (maxX - x3) * .4, y3, maxX, maxY)
        ;
    return interpolation;
  }

  double scaleValue(double value, double minY, double maxY) {
    double maxPossibleValue = 10;
    double scaleUnit = (maxY - minY) / maxPossibleValue;
    return maxY - (scaleUnit * value);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double x = size.width;
    final double y = size.height;

    double minY = y * (2 / 5);
    double maxY = y * (4 / 5);
    double yEmotion = scaleValue(emotion, minY, maxY);
    double yStress = scaleValue(stress, minY, maxY);
    double yAnxiety = scaleValue(anxiety, minY, maxY);

    Paint graphLineStroke = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white
      ..strokeWidth = y * .01;

    Path graphLine = bezierInterpolationOf3Points(
        0.0, minY, x, maxY, yEmotion, yStress, yAnxiety);

    // Path()
    //   ..moveTo(0, y * (2 / 5))
    //   ..lineTo(x, y * (2 / 5))
    //   ..moveTo(0, y * (4 / 5))
    //   ..lineTo(x, y * (4 / 5))
    //   ..moveTo(0, y * (4 / 5))
    //   ..cubicTo(x / 4, y * (4 / 5), x / 4, y * (2 / 5), x / 2, y * (2 / 5))
    //   ..moveTo(x / 2, y * (2 / 5))
    //   ..cubicTo(
    //       x * (3 / 4), y * (2 / 5), x * (3 / 4), y * (4 / 5), x, y * (4 / 5));

    canvas.drawPath(graphLine, graphLineStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
