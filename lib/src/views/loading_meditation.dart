import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:serenity/app/app.router.dart';
import 'package:serenity/src/models/meditation.dart';
import 'package:serenity/src/models/meditation_config.dart';
import 'package:stacked_services/stacked_services.dart';

class LoadingMeditationView extends StatelessWidget {
  final MeditationConfig config;
  final GetIt locator = GetIt.instance;

  LoadingMeditationView({Key? key, required this.config}) : super(key: key);

  Future<http.Response> generateMeditation() {
    Future<http.Response> request = http.get(Uri.parse(
        'https://188s5h8465.execute-api.us-east-1.amazonaws.com/dev/randomize?time=${config.time * 60}&avg=5'));

    // Future.delayed(Duration(seconds: 1), """{"step00":[{"_id":"6169c53d201ebe4f6a58c769","content":"<speak> Bienvenido a tu meditación guiada por Gradúa, espero que esta práctica te traiga muchos beneficios</speak>"}],"step01":[{"_id":"6169c584201ebe4f6a58c77d","content":"<speak> Cierra tus ojos, busca una posición cómoda y quédate quieto. <break time=\"900ms\"/> Busca una postura relajada y atenta a la vez. </speak>"}],"step1":[{"_id":"6169b81336651c7498ee7d1b","content":"<speak> Gandhi decía:No hay camino para la paz, la paz es el camino. <break time=\"900ms\"/>  ¿Con qué? ¿o con quien? <break time=\"300ms\"/>  te hace falta reconciliarte?  <break time=\"900ms\"/>  Lo cierto, es que el rencor es un peso innecesario. </speak>"}],"step2":[{"_id":"6169b8ec36651c7498ee7d28","content":"<speak> En principio, volvamos sobre nuestra postura. <break time=\"1600ms\"/>  ¿estás cómodo y atento?<break time=\"1300ms\"/> ¿tienes tu espalda derecha? <break time=\"1500ms\"/>     apoya tus manos en las piernas o crúzalas en tu regazo. </speak>"}],"step3":[{"_id":"6169ba7a36651c7498ee7d7b","content":"<speak> relájate con cada exhalación.. <break time=\"2600ms\"/> centra tu atención en las sensaciones de tu respiración. <break time=\"2600ms\"/>  INHALA profundamente. <break time=\"4000ms\"/>EXHALA profundamente. <break time=\"4000ms\"/> INHALA. <break time=\"4000ms\"/>EXHALA. <break time=\"4000ms\"/>INHALA. <break time=\"4000ms\"/>EXHALA. <break time=\"4000ms\"/>relájate en cada exhalación. <break time=\"600ms\"/> INHALA. <break time=\"4000ms\"/>EXHALA. <break time=\"4000ms\"/>continua un moemnto.<break time=\"22600ms\"/> </speak> "}],"step4":[{"_id":"6169b94136651c7498ee7d38","content":"<speak> piensa en alguna persona cercana. <break time=\"10600ms\"/> visualízala y recuérdala. <break time=\"5600ms\"/> imagina a esta persona siendo feliz. <break time=\"18600ms\"/> piensa en la felicidad que esta persona ha brindado a los demás. <break time=\"16600ms\"/> </speak>  "}],"step5":[{"_id":"6169b97e36651c7498ee7d46","content":"<speak> ahora enfócate en todos los sonidos que escuches por tres minutos. <break time=\"700ms\"/> si te distraes no te preocupes. <break time=\"800ms\"/>  vuelve a enfocarte en los sonidos del ambiente. <break time=\"180000ms\"/> finaliza dejando tu mente libre de cualquier tarea.<break time=\"25000ms\"/>  </speak> "}],"step6":[{"_id":"6169b9d136651c7498ee7d50","content":"<speak> para finalizar, trae tu atención otra vez  al presente. <break time=\"5000ms\"/> mueve ligeramente cualquier parte del cuerpo que te genere incomodidad o que necesite moverse. <break time=\"8000ms\"/>  date un momento para volver a recuperar tu conciencia. <break time=\"5000ms\"/> ¿como te sientes en este instante? </speak>"}],"step7":[{"_id":"6169ba2036651c7498ee7d5b","content":"<speak> abre los ojos. <break time=\"2000ms\"/> ¿Que tal estuvo la práctica de hoy? <break time=\"3000ms\"/> hemos terminado. Hasta pronto. </speak> "}]}")""

    //TODO Text to speech
    return request;
  }

  @override
  Widget build(BuildContext context) {
    final NavigationService navigationService = locator<NavigationService>();
    double getHeight() {
      return MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom;
    }

    final double height = getHeight();
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        height: height,
        child: FutureBuilder(
          future: generateMeditation(),
          builder: (BuildContext context, AsyncSnapshot snap) {
            if (snap.data == null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Generando Meditación',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: height * 0.035,
                      height: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(width * 0.05),
                    child: SizedBox(
                      width: width * 0.2,
                      height: width * 0.2,
                      child: const CircularProgressIndicator(
                        strokeWidth: 10,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              print("DATA");
              print(snap.data);
              Map<String, dynamic> body =
                  jsonDecode((snap.data as http.Response).body);
              print(body.toString());

              Future.delayed(
                const Duration(milliseconds: 500),
                () => navigationService.replaceWith(
                  Routes.player,
                  arguments: PlayerArguments(
                    meditation: Meditation.fromRawJson(body, config),
                  ),
                ),
              );
              // navigationService.navigateTo(Routes.player);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '¡Éxito!',
                    style: GoogleFonts.poppins(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: height * 0.04,
                      height: 1,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
