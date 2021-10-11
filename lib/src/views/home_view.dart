import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serenity/app/app.router.dart';
import 'package:serenity/src/models/meditation.dart';
import 'package:serenity/src/view_models/home_view_model.dart';
import 'package:serenity/src/views/scroll_sheet.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GetIt locator = GetIt.instance;
  final _controller = PanelController();

  @override
  Widget build(BuildContext context) {
    double getHeight() {
      return MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom;
    }

    final navigationService = locator<NavigationService>();
    final double height = getHeight();
    final width = MediaQuery.of(context).size.width;

    void handlePanelChevronTap() {
      if (_controller.isPanelClosed) {
        _controller.animatePanelToPosition(1,
            curve: Cubic(0.17, 0.67, 0.83, 0.67),
            duration: Duration(milliseconds: 400));
      } else {
        _controller.close();
      }
    }

    Widget createMeditationArea(SimpleMeditation meditation) {
      return InkWell(
        onTap: () {
          navigationService.navigateTo(Routes.player,
              arguments: PlayerArguments(meditation: meditation));
        },
        child: Container(
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
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Icon(
                          CupertinoIcons.clock,
                          color: Color(0xEE8F9BB2),
                          size: height * 0.015,
                        ),
                      ),
                      Text(
                        meditation.formattedDuration(),
                        style: GoogleFonts.openSans(
                          color: Color(0xEE8F9BB2),
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
                    color: Color(0xEEECECEC),
                    size: height * 0.044,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel.exampleData(),
        builder: (context, vm, child) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: Color(0xFFEDCCEE),
              body: ScrollSheet(
                controllerType: ControllerType.fromFields,
                controller: _controller,
                body: Container(
                  child: Padding(
                    padding:
                        EdgeInsets.fromLTRB(0, height * 0.05, 0, height * 0.1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: height * 0.22,
                          width: width * 0.84,
                          decoration: BoxDecoration(
                            color: Color(0x547400B8),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(width * 0.05),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Recommended\n Meditation",
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700,
                                    fontSize: height * 0.03,
                                    height: 1,
                                  ),
                                ),
                                Text(
                                  "Recommendation of the day",
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300,
                                    fontSize: height * 0.019,
                                    height: 1,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      print('Received click');
                                    },
                                    child: Text(
                                      'Listen meditation',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: height * 0.023,
                                        height: 1,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: height * 0.02),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            height * 0.02),
                                      ),
                                      backgroundColor: Colors.transparent,
                                      side: BorderSide(
                                          color: Colors.black,
                                          width: 3,
                                          style: BorderStyle.solid),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          iconSize: height * 0.045,
                          icon: Icon(
                            CupertinoIcons.play_circle,
                          ),
                          onPressed: () => {
                            navigationService.navigateTo(Routes.other_player)
                          },
                        ),
                        Text(
                          'Start session',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: height * 0.023,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
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
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(width * 0.08, height * 0.02,
                        width * 0.08, height * 0.025),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: IconButton(
                              onPressed: handlePanelChevronTap,
                              icon: Icon(
                                CupertinoIcons.chevron_compact_down,
                                size: height * 0.04,
                              ),
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
                                    color: Color(0xFF8C2C8C),
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
                        Spacer(),
                        SizedBox(
                          height: height * 0.45,
                          width: double.infinity,
                          child: ListView.builder(
                              itemCount: vm.savedMeditations.length,
                              itemBuilder: (_, index) => createMeditationArea(
                                  vm.savedMeditations[index])),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
                collapse: Container(
                  decoration: BoxDecoration(
                    color: Color(0xEEF6F5F5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  EdgeInsets.fromLTRB(width * 0.07, 0, 0, 0),
                              child: Icon(
                                CupertinoIcons.tag_solid,
                                size: height * 0.028,
                              ),
                            )),
                        Center(
                            child: IconButton(
                          onPressed: handlePanelChevronTap,
                          icon: Icon(
                            CupertinoIcons.chevron_compact_up,
                            size: height * 0.04,
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                isDraggable: true,
                maxHeight: height * 0.67,
                minHeight: height * 0.06,

                // CupertinoIcons.clock
              ),
            ),
          );
        });
  }
}
