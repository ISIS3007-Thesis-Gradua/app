import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serenity/src/style/gradua_gradients.dart';
import 'package:serenity/src/style/text_theme.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

class Instructions extends StatelessWidget {
  final PanelController controller;
  const Instructions({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

    TextStyle titleTextStyle = GoogleFonts.raleway(
      fontWeight: FontWeight.bold,
      fontSize: height * .02,
    );

    TextStyle subtitleTextStyle = GoogleFonts.raleway(
      fontWeight: FontWeight.w700,
      fontSize: height * .015,
      color: const Color(0xFF8C2C8C),
    );

    TextStyle emphasisTextStyle = GoogleFonts.raleway(
      fontWeight: FontWeight.w700,
      fontSize: height * .015,
      color: const Color(0xFF0071BC),
    );

    ScrollController scrollController = ScrollController();

    return Stack(
      children: [
        SingleChildScrollView(
          controller: scrollController,
          child: Container(
            decoration: BoxDecoration(
              gradient: GraduaGradients.instructionsGradient.linearGradient,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: height * .02, horizontal: width * .05),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: IconButton(
                      onPressed: controller.close,
                      icon: Icon(
                        CupertinoIcons.chevron_down,
                        size: height * 0.025,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFE3EDF7),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(width * .1),
                      child: Column(
                        children: [
                          GradientText(
                            "Tu meditación a la medida en tres pasos:\n",
                            style: titleTextStyle,
                            gradient:
                                GraduaGradients.defaultGradient.linearGradient,
                          ),
                          RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(text: "", children: [
                              TextSpan(text: "1. ", style: subtitleTextStyle),
                              TextSpan(
                                  text: "Selecciona ",
                                  style: emphasisTextStyle),
                              TextSpan(
                                  text: "las variables iniciales ",
                                  style: emphasisTextStyle.copyWith(
                                      fontStyle: FontStyle.italic)),
                              TextSpan(
                                  text: "(TIEMPO, ÁNIMO, ESTRÉS Y ANSIEDAD) ",
                                  style: defaultTextStyle.copyWith(
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      "Así Gradúa creará una meditación que maximice los efectos positivos.\n\n\n",
                                  style: defaultTextStyle),
                              TextSpan(
                                  text: "Variables Iniciales\n\n",
                                  style: emphasisTextStyle),
                              TextSpan(
                                  text: "Tiempo: ",
                                  style: defaultTextStyle.copyWith(
                                      color: Colors.black)),
                              TextSpan(
                                  text:
                                      "Indica cuántos minutos deseas meditar \n\n",
                                  style: defaultTextStyle),
                              TextSpan(
                                  text: "Ánimo: ",
                                  style: defaultTextStyle.copyWith(
                                      color: Colors.black)),
                              TextSpan(
                                  text:
                                      "Califica de 1 a 10 tu estado emocional. Las mayores calificaciones (ej. 9,  10) describen emociones positivas como felicidad, o enamoramiento. \n\n",
                                  style: defaultTextStyle),
                              TextSpan(
                                  text: "Estrés: ",
                                  style: defaultTextStyle.copyWith(
                                      color: Colors.black)),
                              TextSpan(
                                  text:
                                      "Califica de 1 a 10 tu  estrés. Las mayores calificaciones (ej. 9,  10) indican alto nivel de estrés y se asocia con irritación, mal humor, tensión, entre otros. \n ¿Cómo identificar el estrés? \n\n",
                                  style: defaultTextStyle),
                              TextSpan(
                                  text:
                                      "https://www.mayoclinic.org/es-es/healthy-lifestyle/stress-management/in-depth/stress-symptoms/art-20050987 \n\n",
                                  style: defaultTextStyle.copyWith(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => launch(
                                        "https://www.mayoclinic.org/es-es/healthy-lifestyle/stress-management/in-depth/stress-symptoms/art-20050987")),
                              TextSpan(
                                  text: "Ansiedad: ",
                                  style: defaultTextStyle.copyWith(
                                      color: Colors.black)),
                              TextSpan(
                                  text:
                                      "Califica de 1 a 10 tu  ansiedad. Las mayores calificaciones (ej. 9,  10) describen mucha ansiedad y se asocia con miedo, inquietud, negatividad. \n¿Cómo identificar la ansiedad?\n\n",
                                  style: defaultTextStyle),
                              TextSpan(
                                  text:
                                      "https://www.mayoclinic.org/es-es/diseases-conditions/anxiety/symptoms-causes/syc-20350961 \n\n",
                                  style: defaultTextStyle.copyWith(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => launch(
                                        "https://www.mayoclinic.org/es-es/diseases-conditions/anxiety/symptoms-causes/syc-20350961")),
                              TextSpan(
                                  text: "2. Medita, ",
                                  style: subtitleTextStyle),
                              TextSpan(
                                  text:
                                      "1. busca un lugar tranquilo. Utiliza audifonos prefereblemente y sigue las intrucciones del maestro meditador. El reproductor tiene diferentes controles que permiten gestionar la sesión.\n\n",
                                  style: defaultTextStyle),
                              TextSpan(
                                  text: "3. Califica la Experiencia, ",
                                  style: subtitleTextStyle),
                              TextSpan(
                                  text:
                                      "el contraste de resultados te permitirá saber que tipo de meditaciones te convienen más.  Tambien, le permirte Gradúa optimizarce. Gradúa utiliza los datos para mejorar y recomendar mejores y meditaciones. ",
                                  style: defaultTextStyle),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * .1, vertical: width * .1),
            child: IconButton(
              icon: Icon(
                Icons.arrow_circle_up_rounded,
                color: Colors.black,
                size: width * .1,
              ),
              onPressed: () => scrollController.animateTo(0,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOutSine),
            ),
          ),
        )
      ],
    );
  }
}
