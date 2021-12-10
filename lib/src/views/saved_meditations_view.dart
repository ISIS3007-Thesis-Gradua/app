import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serenity/app/app.router.dart';
import 'package:serenity/src/models/meditation.dart';
import 'package:serenity/src/view_models/home_view_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:stacked_services/stacked_services.dart';

class SavedMeditationsView extends StatefulWidget {
  final HomeViewModel vm;
  final PanelController controller;
  const SavedMeditationsView(
      {Key? key, required this.vm, required this.controller})
      : super(key: key);

  @override
  _SavedMeditationsViewState createState() => _SavedMeditationsViewState();
}

class _SavedMeditationsViewState extends State<SavedMeditationsView> {
  late final NavigationService navigationService;
  GetIt locator = GetIt.instance;

  @override
  void initState() {
    navigationService = locator<NavigationService>();
    super.initState();
  }

  void handlePanelChevronTap() {
    if (widget.controller.isPanelClosed) {
      widget.controller.animatePanelToPosition(1,
          curve: const Cubic(0.17, 0.67, 0.83, 0.67),
          duration: const Duration(milliseconds: 400));
    } else {
      widget.controller.close();
    }
  }

  Widget createMeditationArea(
      SimpleMeditation meditation, double width, double height) {
    return InkWell(
      onTap: () {
        navigationService.navigateTo(Routes.player,
            arguments: PlayerArguments(meditation: meditation));
      },
      child: SizedBox(
        height: height * 0.072,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, height * 0.01),
                  child: Text(
                    meditation.name,
                    style: GoogleFonts.openSans(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: height * 0.019,
                      height: 1,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Icon(
                        CupertinoIcons.clock,
                        color: const Color(0xEE8F9BB2),
                        size: height * 0.015,
                      ),
                    ),
                    Text(
                      meditation.formattedDuration(),
                      style: GoogleFonts.openSans(
                        color: const Color(0xEE8F9BB2),
                        fontWeight: FontWeight.w600,
                        fontSize: height * 0.015,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Center(
              child: IconButton(
                onPressed: () => {},
                icon: Icon(
                  CupertinoIcons.play_circle_fill,
                  color: const Color(0xEEECECEC),
                  size: height * 0.044,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double getHeight() {
      return MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom;
    }

    final double height = getHeight();
    final double width = MediaQuery.of(context).size.width;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xEEF6F5F5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            width * 0.08, height * 0.02, width * 0.08, height * 0.025),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: IconButton(
                onPressed: handlePanelChevronTap,
                icon: Icon(
                  CupertinoIcons.chevron_down,
                  size: height * 0.025,
                  color: Colors.white,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Recently saved meditations",
                    style: GoogleFonts.poppins(
                        color: const Color(0xFF8C2C8C),
                        fontWeight: FontWeight.normal,
                        fontSize: height * 0.018),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Your meditations",
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: height * 0.025),
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              height: height * 0.45,
              width: double.infinity,
              child: ListView.builder(
                  itemCount: widget.vm.savedMeditations.length,
                  itemBuilder: (_, index) => createMeditationArea(
                      widget.vm.savedMeditations[index], width, height)),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
