import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serenity/src/components/sliders.dart';
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
              fontSize: height * 0.027);
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.05, vertical: height * 0.07),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Minutos:", style: sliderTextStyle),
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
                Text("Animo:", style: sliderTextStyle),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 20, 17),
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
                    ),
                    const Icon(CupertinoIcons.smiley, color: Colors.black),
                  ],
                ),
                Text("Estrés:", style: sliderTextStyle),
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
                Text("Ansiedad:", style: sliderTextStyle),
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
