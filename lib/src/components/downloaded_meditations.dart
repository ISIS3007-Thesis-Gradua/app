import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serenity/app/app.router.dart';
import 'package:serenity/src/models/meditation.dart';
import 'package:serenity/src/services/local_storage_service.dart';
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
    List<SimpleMeditation> savedMeditations =
        localStorage.getAllSavedMeditations();
    // print(localStorage.getAllSavedMeditations());

    Future<void> deleteMeditation(int index) async {
      // await localStorage.deleteMeditationAtIndex(index);
      await localStorage.deleteMeditationWithKey(savedMeditations[index].id);
      setState(() {
        savedMeditations = localStorage.getAllSavedMeditations();
      });
    }

    double getHeight() {
      return MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom;
    }

    final double height = getHeight();
    final width = MediaQuery.of(context).size.width;

    TextStyle meditationNameStyle = GoogleFonts.raleway(
      fontWeight: FontWeight.w700,
      fontSize: width * .025,
      color: const Color(0xFF768596),
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F9FF),
      ),
      child: ListView.builder(
        itemCount: savedMeditations.length,
        itemBuilder: (context, index) {
          print(savedMeditations[index].duration);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: BasicCard(
              child: ListTile(
                tileColor: Colors.grey.withAlpha(100),
                title: Text(
                  savedMeditations[index].name,
                  style: meditationNameStyle,
                ),
                leading: IconButton(
                  icon: const Icon(
                    CupertinoIcons.play_arrow,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    navigationService.replaceWith(
                      Routes.player,
                      arguments:
                          PlayerArguments(meditation: savedMeditations[index]),
                    );
                  },
                ),
                trailing: IconButton(
                  icon: Icon(CupertinoIcons.delete),
                  color: Colors.redAccent,
                  onPressed: () => deleteMeditation(index),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
