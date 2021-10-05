import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:serenity/src/models/meditation.dart';
import 'package:serenity/src/views/scroll_sheet.dart';
import 'package:stacked_services/stacked_services.dart';

class Player extends StatefulWidget {
  final SimpleMeditation? meditation;
  const Player({Key? key, this.meditation}) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  GetIt locator = GetIt.instance;
  String name = "";
  Duration duration = Duration(seconds: 0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("passed meditation");
    print(widget.meditation);
    if (widget.meditation != null) {
      name = widget.meditation!.name;
      duration = widget.meditation!.duration;
    }
  }

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
          body: Padding(
            padding: EdgeInsets.fromLTRB(width * 0.05, height * 0.03, 0, 0),
            child: Stack(
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(
                        CupertinoIcons.back,
                        size: height * 0.03,
                      ),
                      onPressed: () => {navigationService.back()},
                    )),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(name),
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
                    Icon(
                      CupertinoIcons.heart,
                      size: height * 0.03,
                    ),
                    Icon(
                      CupertinoIcons.play_circle,
                      size: height * 0.055,
                    ),
                    Icon(Icons.settings_voice_outlined, size: height * 0.03)
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.066),
                  child: Slider(
                    activeColor: Color(0xEE8C2C8C),
                    inactiveColor: Color.fromRGBO(0, 0, 0, 0.33),
                    onChanged: (v) {},
                    value: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
