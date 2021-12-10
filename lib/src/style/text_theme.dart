import 'package:flutter/material.dart';

import 'gradua_gradients.dart';

///TODO: Ideally this class would have all the text styles used across the app
///This es left as a todo task.

///Applies the given gradient to a text
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Gradient? gradient;
  final TextAlign align;

  const GradientText(
    this.text, {
    this.gradient,
    this.style,
    this.align = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) =>
          (gradient ?? GraduaGradients.defaultGradient.linearGradient)
              .createShader(
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
