import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:serenity/src/services/navigation_service.dart';
import 'package:serenity/src/views/scroll_sheet.dart';

class Player extends StatefulWidget {
  const Player({Key? key}) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  GetIt locator = GetIt.instance;
  @override
  Widget build(BuildContext context) {
    double getHeight() {
      return MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom;
    }

    final double height = getHeight();
    final width = MediaQuery.of(context).size.width;
    final navigationService = locator<NavigationService>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFEDCCEE),
        body: ScrollSheet(
          isDraggable: false,
          maxHeight: height * 0.35,
          minHeight: height * 0.35,
          body: Expanded(
            child: Stack(
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(CupertinoIcons.back),
                      onPressed: () => {navigationService.goBack()},
                    )),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text("Meditation"),
                )
              ],
            ),
          ),
          panel: Container(
            decoration: BoxDecoration(
              color: Color(0xEEF6F5F5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(CupertinoIcons.heart),
                    Icon(CupertinoIcons.play_circle),
                    Icon(Icons.settings_voice_outlined)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
