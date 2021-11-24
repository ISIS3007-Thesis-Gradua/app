import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serenity/src/components/downloaded_meditations.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  // List<IconData> icons = CupertinoIcons.va

  @override
  Widget build(BuildContext context) {
    double getHeight() {
      return MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom;
    }

    final double height = getHeight();
    final width = MediaQuery.of(context).size.width;

    TextStyle meditationNameStyle = GoogleFonts.raleway(
      fontWeight: FontWeight.w700,
      fontSize: width * .05,
      color: const Color(0xFF768596),
    );
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: height,
      color: const Color(0xFFF6F9FF),
      child: Drawer(
        elevation: 16,
        child: Container(
          color: const Color(0xFFF6F9FF),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Meditaciones Guardadas",
                style: meditationNameStyle,
              ),
              const DonwloadedMeditations(),
              IconButton(
                icon: const Icon(
                  CupertinoIcons.xmark,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
