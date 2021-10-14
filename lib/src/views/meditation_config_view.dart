import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:serenity/src/models/meditation_config.dart';
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
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;
          print(constraints);
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.05, vertical: height * 0.07),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Time of the meditation"),
                Slider(
                  value: vm.meditationConfig.time,
                  min: 2,
                  max: 30,
                  divisions: 28,
                  label: vm.meditationConfig.time.round().toString() + " mins",
                  onChanged: (double value) {
                    setState(() {
                      vm.meditationConfig.time = value;
                    });
                  },
                ),
                Text("How do you feel?"),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: vm.meditationConfig.emotion,
                        min: 0,
                        max: 1,
                        onChanged: (double value) {
                          setState(() {
                            vm.meditationConfig.emotion = value;
                          });
                        },
                      ),
                    ),
                    const Icon(CupertinoIcons.smiley),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("What is your Goal with this meditation?"),
                ),
                CupertinoPicker(
                  // useMagnifier: true,
                  // magnification: 1.2,
                  diameterRatio: 0.8,
                  itemExtent: height * 0.13,
                  onSelectedItemChanged: (int value) {
                    print("Selected item: $value");
                  },
                  children: MeditationGoals.values
                      .map<Widget>((name) => Text(
                            name.toString().split('.').last,
                          ))
                      .toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
