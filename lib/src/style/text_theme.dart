import 'package:flutter/material.dart';

///TODO: Ideally this class would have all the text styles used across the app
///This es left as a todo task.

///Aplies the given gradient to a text
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
