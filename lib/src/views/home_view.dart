import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serenity/app/app.router.dart';
import 'package:serenity/src/components/buttons.dart';
import 'package:serenity/src/components/cards.dart';
import 'package:serenity/src/components/collapsed_container.dart';
import 'package:serenity/src/components/helper_dialog.dart';
import 'package:serenity/src/components/instructions.dart';
import 'package:serenity/src/utils/gradua_icons.dart';
import 'package:serenity/src/view_models/home_view_model.dart';
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

    const String assetName = 'assets/images/meditating_man.svg';

    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel.exampleData(),
        builder: (context, vm, child) {
          return Scaffold(
            backgroundColor: const Color(0xFFF6F9FF),
            body: ScrollSheet(
              controllerType: ControllerType.fromFields,
              controller: _controller,
              body: Padding(
                padding: EdgeInsets.fromLTRB(0, height * 0.05, 0, height * 0.1),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        BasicCard(
                          height: height * 0.22,
                          width: width * 0.84,
                          child: Padding(
                            padding: EdgeInsets.all(height * 0.02),
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                Positioned(
                                  top: 5,
                                  right: width * .01,
                                  child: getHelperButton(
                                      HelperDialog.recommendation, context),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(height * .02),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  assetName,
                                  semanticsLabel: 'Acme Logo',
                                  height: height * .2,
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0, 0, width * .2, 0),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: getHelperButton(
                                      HelperDialog.meditationBenefits, context),
                                ),
                              ),
                            ],
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
                                  GraduaIcons.peace,
                                  size: height * 0.035,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              panel: Instructions(controller: _controller),
              collapse: CollapsedContainer(_controller, height, width),
              isDraggable: true,
              maxHeight: height * 0.67,
              minHeight: height * 0.06,

              // CupertinoIcons.clock
            ),
          );
        });
  }
}
