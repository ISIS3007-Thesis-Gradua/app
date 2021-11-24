import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serenity/app/app.router.dart';
import 'package:serenity/src/components/buttons.dart';
import 'package:serenity/src/components/cards.dart';
import 'package:serenity/src/components/collapsed_container.dart';
import 'package:serenity/src/components/helper_dialog.dart';
import 'package:serenity/src/components/instructions.dart';
import 'package:serenity/src/components/sliders.dart';
import 'package:serenity/src/models/emotions_measure.dart';
import 'package:serenity/src/models/meditation.dart';
import 'package:serenity/src/utils/gradua_icons.dart';
import 'package:serenity/src/view_models/meditation_rating_view_model.dart';
import 'package:serenity/src/view_models/player_view_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:stacked_services/stacked_services.dart';

class MeditationRatingView extends StatefulWidget {
  EmotionsMeasure prevEmotionsMeasure;
  TtsSource ttsSource;
  SimpleMeditation simpleMeditation;
  MeditationRatingView(
      {Key? key,
      required this.prevEmotionsMeasure,
      required this.simpleMeditation,
      required this.ttsSource})
      : super(key: key);

  @override
  _MeditationRatingViewState createState() => _MeditationRatingViewState();
}

class _MeditationRatingViewState extends State<MeditationRatingView> {
  GetIt locator = GetIt.instance;
  final _controller = PanelController();
  late final NavigationService navigationService;
  MeditationRatingViewModel vm = MeditationRatingViewModel();
  double anxiety = 0;

  @override
  void initState() {
    navigationService = locator<NavigationService>();
    vm.init(widget.prevEmotionsMeasure);
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

    final TextStyle sliderTextStyle = GoogleFonts.raleway(
      fontWeight: FontWeight.w800,
      color: const Color(0xFF8B9EB0),
      fontSize: height * .017,
    );
    // print("Building");
    // print(anxiety);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SlidingUpPanel(
            backdropOpacity: 0.17,
            controller: _controller,
            isDraggable: false,
            maxHeight: height * 0.67,
            minHeight: height * 0.06,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            collapsed: CollapsedContainer(_controller, height, width),
            panel: Instructions(
              controller: _controller,
            ),
            body: Padding(
              padding: EdgeInsets.fromLTRB(
                  0,
                  MediaQuery.of(context).padding.top + height * .02,
                  0,
                  height * .1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BasicCard(
                    width: width * .85,
                    height: height * .2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/logo_gradua_horizontal.png",
                          height: height * .06,
                        ),
                        Text(
                          "¡Hey!\nAhora ¿Cómo te sientes?",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                            fontWeight: FontWeight.w700,
                            fontSize: height * .018,
                            color: Color(0xFF727D8F),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(height * 0.03),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(height * 0.03),
                        child: SvgPicture.asset(
                          'assets/images/black_woman_meditating.svg',
                          semanticsLabel: 'Acme Logo',
                          height: height * .15,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.05, vertical: height * 0.01),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text("Animo:", style: sliderTextStyle)),
                            Expanded(
                              child: Center(
                                child: Icon(
                                  GraduaIcons.theater_masks,
                                  color: const Color(0xFF8B9EB0),
                                  size: width * .04,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  CupertinoIcons.question_circle,
                                  color: const Color(0xFF8B9EB0),
                                  size: width * .04,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 17),
                          child: GradientSlider(
                            value: vm.posEmotions.emotion,
                            min: 0,
                            max: 10,
                            divisions: 10,
                            onChanged: (value) {
                              // print(value);
                              setState(() {
                                vm.posEmotions.emotion = value;
                                // vm.setPosEmotion(value);
                              });
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text("Estrés:", style: sliderTextStyle)),
                            Expanded(
                              child: Center(
                                child: Icon(
                                  GraduaIcons.brain,
                                  color: const Color(0xFF8B9EB0),
                                  size: width * .04,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  CupertinoIcons.question_circle,
                                  color: const Color(0xFF8B9EB0),
                                  size: width * .04,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 17),
                          child: GradientSlider(
                            value: vm.posEmotions.stress,
                            min: 0,
                            max: 10,
                            divisions: 10,
                            onChanged: (value) {
                              setState(() {
                                vm.posEmotions.stress = value;
                              });
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child:
                                    Text("Ansiedad:", style: sliderTextStyle)),
                            Expanded(
                              child: Center(
                                child: Icon(
                                  GraduaIcons.rain,
                                  color: const Color(0xFF8B9EB0),
                                  size: width * .04,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  CupertinoIcons.question_circle,
                                  color: const Color(0xFF8B9EB0),
                                  size: width * .04,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 8, 0, 17),
                          child: GradientSlider(
                            value: vm.posEmotions.anxiety,
                            min: 0,
                            max: 10,
                            divisions: 10,
                            onChanged: (value) {
                              setState(() {
                                vm.posEmotions.anxiety = value;
                              });
                            },
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Política de tratamiento de datos: ",
                              style: sliderTextStyle,
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: height * .02),
                              child: getHelperButton(
                                  HelperDialog.dataPolicy, context),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RoundedGradientButton.text(
                              buttonText: "Terminar",
                              width: width * 0.6,
                              height: height * 0.065,
                              fontSize: height * 0.02,
                              onPressed: () {
                                navigationService.replaceWith(Routes.graph_view,
                                    arguments: GraphViewArguments(
                                      prevEmotionsMeasure:
                                          widget.prevEmotionsMeasure,
                                      posEmotionsMeasure: vm.posEmotions,
                                      simpleMeditation: widget.simpleMeditation,
                                      ttsSource: widget.ttsSource,
                                    ));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
