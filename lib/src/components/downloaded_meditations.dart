import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serenity/app/app.router.dart';
import 'package:serenity/src/models/meditation.dart';
import 'package:serenity/src/services/local_storage_service.dart';
import 'package:serenity/src/style/text_theme.dart';
import 'package:serenity/src/utils/datetime_utils.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'cards.dart';

class DonwloadedMeditations extends StatefulWidget {
  const DonwloadedMeditations({Key? key}) : super(key: key);

  @override
  _DonwloadedMeditationsState createState() => _DonwloadedMeditationsState();
}

class _DonwloadedMeditationsState extends State<DonwloadedMeditations> {
  StackedLocator locator = StackedLocator.instance;
  @override
  Widget build(BuildContext context) {
    LocalStorageService localStorage = locator<LocalStorageService>();
    NavigationService navigationService = locator<NavigationService>();

    void deleteGivenMeditation(SimpleMeditation meditation) {
      localStorage.deleteMeditationWithKey(meditation.id);
    }

    double getHeight() {
      return MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom;
    }

    final double height = getHeight();
    final width = MediaQuery.of(context).size.width;

    TextStyle meditationNameStyle = GoogleFonts.raleway(
      fontWeight: FontWeight.bold,
      fontSize: width * .03,
      color: Colors.black,
      // color: const Color(0xFF768596),
    );

    TextStyle pageTitleStyle = meditationNameStyle.copyWith(
      fontSize: width * .05,
      color: Colors.black,
    );
    TextStyle subtitleStyle =
        pageTitleStyle.copyWith(fontSize: width * .025, color: Colors.black54);

    return StreamBuilder<List<SimpleMeditation>>(
        stream: localStorage.watchAllSavedMeditations(),
        builder: (context, snapshot) {
          List<SimpleMeditation> savedMeditations = snapshot.data ?? [];
          return Padding(
            padding: EdgeInsets.fromLTRB(0, height * .05, 0, 0),
            child: Column(
              children: [
                GradientText("Meditaciones Guardadas", style: pageTitleStyle),
                Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF6F9FF),
                  ),
                  child: ListView.builder(
                    itemCount: savedMeditations.length,
                    itemBuilder: (context, index) {
                      print(savedMeditations[index].duration);
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: BasicCard(
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            tileColor: Colors.grey.withAlpha(100),
                            title: Text(savedMeditations[index].name,
                                style: meditationNameStyle),
                            subtitle: Text(
                              formatDuration(
                                Duration(
                                    seconds: savedMeditations[index]
                                        .durationInSeconds
                                        .round()),
                              ),
                              style: subtitleStyle,
                            ),
                            leading: IconButton(
                              icon: const Icon(
                                CupertinoIcons.play_arrow,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                navigationService.replaceWith(
                                  Routes.player,
                                  arguments: PlayerArguments(
                                      meditation: savedMeditations[index]),
                                );
                              },
                            ),
                            trailing: IconButton(
                              icon: const Icon(CupertinoIcons.delete),
                              color: Colors.redAccent,
                              onPressed: () => deleteGivenMeditation(
                                  savedMeditations[index]),
                            ),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}
