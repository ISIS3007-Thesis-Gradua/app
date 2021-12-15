import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

///Enum of radients used across the app
enum GraduaGradients {
  helperTitleGradient,
  defaultGradient,
  instructionsGradient,
  neomorphicButtonGradient,
  basicCardGradient,
  successAlertGradient,
  errorAlertGradient,
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
      case GraduaGradients.basicCardGradient:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xA3A6D5FF),
            Color(0xFFC9E0FF),
            Color(0xFFE2EFFD),
          ],
          stops: [0, 0.5, 0.9],
        );
      case GraduaGradients.successAlertGradient:
        return LinearGradient(
          transform: GradientRotation(radians(0)),
          // begin: Alignment.topLeft,
          // end: Alignment.bottomRight,
          colors: const [
            Color(0xFF92FE9D),
            Color(0xFF00C9FF),
          ],
        );
      case GraduaGradients.errorAlertGradient:
        return LinearGradient(
          transform: GradientRotation(radians(-90)),
          // begin: Alignment.topLeft,
          // end: Alignment.bottomRight,
          colors: const [
            Color(0xFFBF072A),
            Color(0xFFFFB199),
          ],
        );
    }
  }

  Color get textContrastingColor {
    switch (this) {
      case GraduaGradients.helperTitleGradient:
        return Colors.white;
      case GraduaGradients.defaultGradient:
        return Colors.white;
      case GraduaGradients.instructionsGradient:
        return Colors.white;
      case GraduaGradients.neomorphicButtonGradient:
        return Colors.black54;
      case GraduaGradients.basicCardGradient:
        return const Color(0xFF768596);
      case GraduaGradients.successAlertGradient:
        return Colors.black;
      case GraduaGradients.errorAlertGradient:
        return Colors.white;
    }
  }
}

///This is for adding a Gradient Shader to the given child.
///Can be used in text, icons, images, basically everything that needs a
///Gradient on top.
Widget maskGradient(
    {required Widget child,
    required Gradient gradient,
    BlendMode blendMode = BlendMode.srcIn}) {
  return ShaderMask(
    blendMode: blendMode,
    shaderCallback: (bounds) => gradient.createShader(
      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
    ),
    child: child,
  );
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
