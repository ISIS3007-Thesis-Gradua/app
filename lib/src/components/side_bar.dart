import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:serenity/src/components/download_in_progress.dart';
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

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: height,
        child: Drawer(
          elevation: 16,
          child: Container(
            color: const Color(0xFFF6F9FF),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const DownloadsInProgress(),
                  const DonwloadedMeditations(),
                  const Spacer(flex: 1),
                  IconButton(
                    icon: const Icon(
                      CupertinoIcons.xmark,
                      color: Colors.black,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}