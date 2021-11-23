import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Drawer(
        elevation: 16,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DonwloadedMeditations(),
              Text("Meditaciones Guardadas"),
              IconButton(
                icon: Icon(CupertinoIcons.xmark),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
