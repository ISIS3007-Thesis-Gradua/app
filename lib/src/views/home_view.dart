import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serenity/app/app.router.dart';
import 'package:serenity/src/components/buttons.dart';
import 'package:serenity/src/components/collapsed_container.dart';
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
                            BoxShadow(
                              color: Color(0xFFEBEFF3),
                              spreadRadius: 1,
                              blurRadius: 30,
                              offset:
                                  Offset(-5, -10), // changes position of shadow
                            ),
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
                          padding: EdgeInsets.all(height * 0.02),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "¡Hola! Bienvenido a Gradúa. \nDeseas iniciar con una \nmeditación sugerida?",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.raleway(
                                  color: Color(0xFF768596),
                                  fontWeight: FontWeight.w700,
                                  fontSize: height * 0.022,
                                  height: 1,
                                ),
                              ),
                              RoundedGradientButton.text(
                                buttonText: "Meditar Ahora",
                                width: width * 0.6,
                                height: height * 0.065,
                                fontSize: height * 0.02,
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                      MeditationConfigView(vm: vm),
                      // const Spacer(),
                      RoundedGradientButton(
                        width: width * 0.6,
                        height: height * 0.065,
                        onPressed: () => {
                          navigationService.navigateTo(
                            Routes.loading_meditation,
                            arguments: LoadingMeditationViewArguments(
                              config: vm.meditationConfig,
                            ),
                          ),
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Meditar Ahora",
                              style: GoogleFonts.raleway(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: height * 0.02,
                                height: 1,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                CupertinoIcons.play_circle,
                                size: height * 0.035,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                panel: SavedMeditationsView(vm: vm, controller: _controller),
                collapse: CollapsedContainer(_controller, height, width),
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
