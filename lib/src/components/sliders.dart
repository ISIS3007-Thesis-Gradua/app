import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class GradientSlider extends StatefulWidget {
  double value;
  double min;
  double max;
  int? divisions;
  void Function(double) onChanged;
  GradientSlider(
      {Key? key,
      required this.value,
      this.min = 0,
      this.max = 1,
      this.divisions,
      required this.onChanged})
      : super(key: key);

  @override
  _GradientSliderState createState() => _GradientSliderState();
}

class _GradientSliderState extends State<GradientSlider> {
  final double trackHeight = 8;
  final double trackRadius = 8;
  final double thumbWidth = 100;

  @override
  Widget build(BuildContext context) {
    // print("Building shit slider");
    return Container(
      height: 20,
      width: double.infinity,
      decoration: BoxDecoration(
        // color: Colors.white,
        gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xCBA6D5FF),
              Color(0xCBB2D6FF),
              Color(0xCBCDE9FF),
            ],
            stops: [
              0,
              0.4,
              0.95
            ]),
        borderRadius: BorderRadius.all(
          Radius.circular(trackRadius),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: (thumbWidth / 2) - 20),
        child: Row(
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.transparent,
                  inactiveTrackColor: Colors.transparent,
                  trackShape: RoundedRectSliderTrackShape(),
                  trackHeight: trackHeight,
                  thumbColor: Colors.redAccent,
                  thumbShape: CustomSliderThumbRect(
                      thumbRadius: trackRadius,
                      thumbWidth: thumbWidth,
                      min: 2,
                      max: 20),
                  // overlayColor: Colors.red.withAlpha(32),
                  // overlayShape: RoundSliderOverlayShape(overlayRadius: 30.0),
                  tickMarkShape: RoundSliderTickMarkShape(),
                  activeTickMarkColor: Colors.white,
                  inactiveTickMarkColor: Colors.white,
                  valueIndicatorShape: RectangularSliderValueIndicatorShape(),
                  valueIndicatorColor: Colors.blueAccent[100],
                  valueIndicatorTextStyle: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: Slider(
                  min: widget.min,
                  max: widget.max,
                  value: widget.value,
                  label: '${widget.value}',
                  divisions: widget.divisions,
                  onChanged: (value) {
                    setState(() {
                      widget.onChanged(value);
                    });
                    // widget.onChanged(value);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSliderThumbRect extends SliderComponentShape {
  final double thumbRadius;
  final double thumbWidth;
  final int min;
  final int max;
  final double height = 15;

  const CustomSliderThumbRect({
    required this.thumbRadius,
    required this.thumbWidth,
    required this.min,
    required this.max,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final thumbShape = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: thumbWidth, height: height),
      Radius.circular(thumbRadius),
    ); //Thumb shape

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = ui.Gradient.linear(
        Offset(center.dx - (thumbWidth / 2), center.dy),
        Offset(center.dx + (thumbWidth / 2), center.dy),
        [
          const Color(0xFF0071BC),
          const Color(0xFF8C2C8C),
        ],
      ); // Thumb Background Color

    canvas.drawRRect(thumbShape, paint); //Paint Basic Thumb

    final Paint paintThumbBorder = Paint()
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..shader = ui.Gradient.linear(
        Offset(center.dx - (thumbWidth / 2), center.dy),
        Offset(center.dx + (thumbWidth / 2), center.dy),
        [
          const Color(0x750071BC),
          const Color(0x758C2C8C),
        ],
      ); // Thumb Border Color

    canvas.drawRRect(thumbShape, paintThumbBorder); //Paint Thumb Border

    final Path leftPath = Path() //Left white line
      ..moveTo(center.dx - 8, center.dy - ((height - 11) / 2))
      ..lineTo(center.dx - 8, center.dy + ((height - 11) / 2));

    final Path rightPath = Path() //Right white line
      ..moveTo(center.dx + 8, center.dy - ((height - 11) / 2))
      ..lineTo(center.dx + 8, center.dy + ((height - 11) / 2));

    final Path centerPath = Path() //Center White line
      ..moveTo(center.dx, center.dy - ((height - 6) / 2))
      ..lineTo(center.dx, center.dy + ((height - 6) / 2));

    final Paint pathPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(leftPath, pathPaint);
    canvas.drawPath(rightPath, pathPaint);
    canvas.drawPath(centerPath, pathPaint);

    // TextSpan span = TextSpan(
    //     style: TextStyle(
    //         fontSize: thumbWidth * .3,
    //         fontWeight: FontWeight.w700,
    //         color: sliderTheme.thumbColor,
    //         height: 1),
    //     text: getValue(value));
    // TextPainter tp = TextPainter(
    //     text: span,
    //     textAlign: TextAlign.left,
    //     textDirection: TextDirection.ltr);
    // tp.layout();
    // Offset textCenter =
    //     Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2));
    // canvas.drawCircle(center, 20, paint);
    // tp.paint(canvas, textCenter);
  }

  String getValue(double value) {
    return (min + (max - min) * value).round().toString();
  }
}
