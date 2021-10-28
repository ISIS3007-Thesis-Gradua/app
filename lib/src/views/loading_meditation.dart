import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serenity/app/app.router.dart';
import 'package:serenity/src/models/meditation.dart';
import 'package:serenity/src/models/meditation_config.dart';
import 'package:stacked_services/stacked_services.dart';

class LoadingMeditationView extends StatelessWidget {
  final MeditationConfig config;
  final GetIt locator = GetIt.instance;

  LoadingMeditationView({Key? key, required this.config}) : super(key: key);

  Future<String> generateMeditation() {
    return Future.delayed(Duration(milliseconds: 500),
        () => "Ay mi madre le bichoooo. Que golazoooooo");

    //TODO Text to speech
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
                    'Generating Meditation',
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
              Future.delayed(
                const Duration(milliseconds: 700),
                () => navigationService.replaceWith(
                  Routes.player,
                  arguments: PlayerArguments(
                    meditation: Meditation(
                      meditationText:
                          "Prueba de texto de meditación. Probando probando probando. Uno, dos y tres.",
                      config: config,
                    ),
                  ),
                ),
              );
              // navigationService.navigateTo(Routes.player);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Succes!',
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
