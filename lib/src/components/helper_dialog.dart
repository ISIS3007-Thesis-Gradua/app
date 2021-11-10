import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serenity/src/style/gradua_gradients.dart';
import 'package:serenity/src/style/text_theme.dart';
import 'package:serenity/src/utils/string_manipulation.dart';

import 'buttons.dart';

const dialogPath = "assets/settings/helper_dialogs.json";

enum HelperDialog {
  recommendation,
  meditationBenefits,
  aiGuidedMeditation,
  dataPolicy,
  resultsInterpretation
}

extension HelperDialogExtension on HelperDialog {
  String get keyName {
    switch (this) {
      case HelperDialog.recommendation:
        return "recomendacion";
      case HelperDialog.meditationBenefits:
        return "beneficios";
      case HelperDialog.aiGuidedMeditation:
        return "meditacionGuiada";
      case HelperDialog.dataPolicy:
        return "politicaDatos";
      case HelperDialog.resultsInterpretation:
        return "interpretacion";
      default:
        return "default";
    }
  }
}

Future<Map<String, dynamic>> loadJson(String path) async {
  String data = await rootBundle.loadString(path);
  Map<String, dynamic> jsonResult = json.decode(data);
  return jsonResult;
}

Future<void> getHelperDialog(HelperDialog dialog, BuildContext context) {
  return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      builder: (BuildContext context) {
        double getHeight() {
          return MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom;
        }

        final double height = getHeight();
        final width = MediaQuery.of(context).size.width;

        TextStyle defaultTextStyle = GoogleFonts.raleway(
          fontWeight: FontWeight.w700,
          fontSize: height * .015,
          color: const Color(0xFF8B9EB0),
        );
        TextStyle graduaTextStyle = GoogleFonts.raleway(
          fontWeight: FontWeight.w700,
          fontSize: height * .015,
          color: const Color(0xFF8C2C8C),
        );

        TextStyle titleTextStyle = GoogleFonts.raleway(
          fontWeight: FontWeight.bold,
          fontSize: height * .04,
        );

        TextStyle subtitleTextStyle = GoogleFonts.raleway(
          fontWeight: FontWeight.bold,
          fontSize: height * .02,
        );

        return FutureBuilder(
            future: loadJson(dialogPath),
            builder: (BuildContext context, AsyncSnapshot snap) {
              // print("CONTENIDO");
              // print(snap.data?[dialog.keyName]?["content"] ?? "nulleando");
              String title = snap.data?[dialog.keyName]?["title"] ??
                  snap.data?["default"]?["title"] ??
                  "Título";
              String subtitle = snap.data?[dialog.keyName]?["subtitle"] ??
                  snap.data?["default"]?["subtitle"] ??
                  "Subtítulo";
              String content = snap.data?[dialog.keyName]?["content"] ??
                  snap.data?["default"]?["content"] ??
                  "Contenido";
              // print(title);
              // print(content);
              //Docs of this specific regex: https://regex101.com/r/4Cr9cB/1
              RegExp pattern = RegExp("Gradua|Gradúa|##[^##]*##",
                  caseSensitive: false, dotAll: true);
              return Wrap(
                children: [
                  Container(
                    height: height * .7,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE3EDF7),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.question_circle_fill,
                          size: height * .06,
                          color: Colors.grey,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  GradientText(
                                    title,
                                    style: titleTextStyle,
                                    gradient: GraduaGradients
                                        .helperTitleGradient.linearGradient,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * .15),
                                    child: GradientText(
                                      subtitle,
                                      style: subtitleTextStyle,
                                      gradient: GraduaGradients
                                          .defaultGradient.linearGradient,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width * .1),
                          child: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              text: '',
                              style: defaultTextStyle,
                              children:
                                  separateStringByPattern(content, pattern)
                                      .map((s) {
                                TextStyle style = defaultTextStyle;
                                if (pattern.hasMatch(s)) {
                                  s = s.replaceAll("##", "");
                                  style = graduaTextStyle;
                                }
                                return TextSpan(text: s, style: style);
                              }).toList(),
                            ),
                          ),
                        ),
                        RoundedGradientButton.text(
                          buttonText: "Volver",
                          width: width * .4,
                          height: width * .12,
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                  ),
                ],
              );
            });
      });
}

Widget getHelperButton(HelperDialog dialog, BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  return IconButton(
    padding: EdgeInsets.zero,
    constraints: const BoxConstraints(),
    icon: Icon(
      CupertinoIcons.question_circle,
      color: const Color(0xFF8B9EB0),
      size: width * .04,
    ),
    onPressed: () => getHelperDialog(dialog, context),
  );
}
