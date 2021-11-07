import 'package:flutter/cupertino.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

enum GraduaGradients {
  helperTitleGradient,
  defaultGradient,
  instructionsGradient,
  neomorphicButtonGradient,
}

extension GraduaGradientsValues on GraduaGradients {
  Gradient get linearGradient {
    switch (this) {
      case GraduaGradients.helperTitleGradient:
        return LinearGradient(
          transform: GradientRotation(radians(90)),
          colors: const [
            Color(0xFF8C2C8C),
            Color(0xFF0071BC),
          ],
        );
      case GraduaGradients.defaultGradient:
        return LinearGradient(
            transform: GradientRotation(radians(-315)),
            colors: const [
              Color(0xFFFF057C),
              Color(0xff7C64D5),
              Color(0xFF4CC3FF),
            ],
            stops: const [0.0, 0.48, 1.0],
            tileMode: TileMode.repeated);
      case GraduaGradients.instructionsGradient:
        return const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0x8C8C2C8C), Color(0x8C0071BC)]);
      case GraduaGradients.neomorphicButtonGradient:
        return LinearGradient(
          transform: GradientRotation(radians(60)),
          colors: const [
            Color(0xFFF3FEFF),
            Color(0xFFCCD5DE),
          ],
        );
    }
  }
}

Color _intToColor(int hexNumber) => Color.fromARGB(
    255,
    (hexNumber >> 16) & 0xFF,
    ((hexNumber >> 8) & 0xFF),
    (hexNumber >> 0) & 0xFF);

/// String To Material color
Color stringToColor(String hex) =>
    _intToColor(int.parse(_textSubString(hex) ?? "0", radix: 16));

String? _textSubString(String text) {
  if (text == null) return null;

  if (text.length < 6) return null;

  if (text.length == 6) return text;

  return text.substring(1, text.length);
}

Widget maskGradient({required Widget child, required Gradient gradient}) {
  return ShaderMask(
    blendMode: BlendMode.srcIn,
    shaderCallback: (bounds) => gradient.createShader(
      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
    ),
    child: child,
  );
}
