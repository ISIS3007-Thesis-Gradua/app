import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serenity/src/components/helper_dialog.dart';
import 'package:serenity/src/components/sliders.dart';
import 'package:serenity/src/utils/gradua_icons.dart';
import 'package:serenity/src/view_models/home_view_model.dart';

class MeditationConfigView extends StatefulWidget {
  final HomeViewModel vm;
  const MeditationConfigView({Key? key, required this.vm}) : super(key: key);

  @override
  _MeditationConfigViewState createState() => _MeditationConfigViewState();
}

class _MeditationConfigViewState extends State<MeditationConfigView> {
  late final HomeViewModel vm;
  Duration time = Duration.zero;

  @override
  void initState() {
    vm = widget.vm;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // List<String> goals = MeditationGoals.values
    //     .map<String>((name) => name.toString().split('.').last)
    //     .toList();
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;

          TextStyle sliderTextStyle = GoogleFonts.raleway(
              fontWeight: FontWeight.w800,
              color: Color(0xFF8B9EB0),
              fontSize: width * 0.04);
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.05, vertical: height * 0.07),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text("Minutos:", style: sliderTextStyle),
                    ),
                    Expanded(
                      child: Center(
                        child: Icon(
                          CupertinoIcons.clock_fill,
                          color: const Color(0xFF8B9EB0),
                          size: width * .04,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: getHelperButton(
                            HelperDialog.aiGuidedMeditation, context),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 17),
                  child: GradientSlider(
                    value: vm.meditationConfig.time,
                    min: 3,
                    max: 30,
                    divisions: 9,
                    // label: vm.meditationConfig.time.round().toString() + " mins",
                    onChanged: (double value) {
                      setState(() {
                        vm.meditationConfig.time = value;
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text("Animo:", style: sliderTextStyle)),
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
                        child: getHelperButton(
                            HelperDialog.aiGuidedMeditation, context),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 17),
                  child: GradientSlider(
                    value: vm.meditationConfig.emotion,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    onChanged: (value) {
                      setState(() {
                        vm.meditationConfig.emotion = value;
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text("Estrés:", style: sliderTextStyle)),
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
                        child: getHelperButton(
                            HelperDialog.aiGuidedMeditation, context),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 17),
                  child: GradientSlider(
                    value: vm.meditationConfig.stress,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    onChanged: (value) {
                      setState(() {
                        vm.meditationConfig.stress = value;
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text("Ansiedad:", style: sliderTextStyle)),
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
                        child: getHelperButton(
                            HelperDialog.aiGuidedMeditation, context),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 17),
                  child: GradientSlider(
                    value: vm.meditationConfig.anxiety,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    onChanged: (value) {
                      setState(() {
                        vm.meditationConfig.anxiety = value;
                      });
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
