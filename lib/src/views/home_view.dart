import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serenity/app/app.router.dart';
import 'package:serenity/src/view_models/home_view_model.dart';
import 'package:serenity/src/views/saved_meditations_view.dart';
import 'package:serenity/src/views/scroll_sheet.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'meditation_config_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GetIt locator = GetIt.instance;
  final _controller = PanelController();
  late final NavigationService navigationService;

  void handlePanelChevronTap() {
    if (_controller.isPanelClosed) {
      _controller.animatePanelToPosition(1,
          curve: const Cubic(0.17, 0.67, 0.83, 0.67),
          duration: const Duration(milliseconds: 400));
    } else {
      _controller.close();
    }
  }

  @override
  void initState() {
    navigationService = locator<NavigationService>();
    super.initState();
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

    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel.exampleData(),
        builder: (context, vm, child) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF6F9FF),
              body: ScrollSheet(
                controllerType: ControllerType.fromFields,
                controller: _controller,
                body: Padding(
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
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFFC5D2FA),
                              spreadRadius: 0,
                              blurRadius: 30,
                              offset:
                                  Offset(5, 10), // changes position of shadow
                            ),
                            // BoxShadow(
                            //   color: Color(0xFFEDF2FF),
                            //   spreadRadius: 1,
                            //   blurRadius: 2,
                            //   offset:
                            //       Offset(10, 10), // changes position of shadow
                            // ),
                          ],
                          gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                // Color(0xFFC5DDF1),
                                // Color(0x88FFFFFF),
                                Color(0xA3A6D5FF),
                                Color(0xFFC9E0FF),
                                Color(0xFFE2EFFD),
                              ],
                              stops: [
                                0,
                                0.5,
                                0.9
                              ]),
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
                                      borderRadius:
                                          BorderRadius.circular(height * 0.02),
                                    ),
                                    backgroundColor: Colors.transparent,
                                    side: const BorderSide(
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
                      MeditationConfigView(vm: vm),
                      // const Spacer(),
                      IconButton(
                        iconSize: height * 0.045,
                        icon: const Icon(
                          CupertinoIcons.play_circle,
                        ),
                        onPressed: () => {
                          navigationService.navigateTo(
                            Routes.loading_meditation,
                            arguments: LoadingMeditationViewArguments(
                              config: vm.meditationConfig,
                            ),
                          ),
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
                panel: SavedMeditationsView(vm: vm, controller: _controller),
                collapse: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xEEF6F5F5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0x8C8C2C8C), Color(0x8C0071BC)],
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(width * 0.07, 0, 0, 0),
                            child: Text(
                              "Instrucciones",
                              style: GoogleFonts.raleway(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                        Center(
                            child: IconButton(
                          onPressed: handlePanelChevronTap,
                          icon: Icon(
                            CupertinoIcons.chevron_up,
                            size: height * 0.025,
                            color: Colors.white,
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
