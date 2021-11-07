import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Gradient gradient;
  final TextAlign align;

  const GradientText(
    this.text, {
    required this.gradient,
    this.style,
    this.align = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: style,
        textAlign: align,
      ),
    );
  }
}

// TextSpan InlineGradientText(String text,
//     {required Gradient gradient, TextStyle? style, Size? size}) {
//   Shader shader = gradient.createShader(
//     Rect.fromCircle(
//       center: Offset(style?.fontSize ?? 400, -200),
//       radius: style?.fontSize ?? 200 / 3,
//     ),
//     textDirection: TextDirection.ltr,
//   );
//
//   return TextSpan(
//       text: text,
//       style: style?.copyWith(
//         foreground: Paint()..shader = shader,
//       ));
// }

// class InlineGradientText {
//   final String text;
//   final TextStyle? style;
//   final Gradient gradient;
//   final TextAlign align;
//   final Widget? child;
//   const InlineGradientText(
//     this.text, {
//     required this.gradient,
//     this.style,
//     this.align = TextAlign.center,
//     this.child,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       this.text,
//     );
//   }
// }
