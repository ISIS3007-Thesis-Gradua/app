import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:serenity/src/components/cards.dart';
import 'package:serenity/src/components/collapsed_container.dart';
import 'package:serenity/src/components/graphs.dart';
import 'package:serenity/src/models/emotions_measure.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:stacked_services/stacked_services.dart';

class GraphView extends StatefulWidget {
  final EmotionsMeasure prevEmotionsMeasure;
  final EmotionsMeasure posEmotionsMeasure;
  const GraphView(this.prevEmotionsMeasure, this.posEmotionsMeasure, {Key? key})
      : super(key: key);

  @override
  _GraphViewState createState() => _GraphViewState();
}

class _GraphViewState extends State<GraphView> {
  GetIt locator = GetIt.instance;
  final _controller = PanelController();
  late final NavigationService navigationService;
  late final Map<String, EmotionsMeasure> measures;

  @override
  void initState() {
    navigationService = locator<NavigationService>();
    measures = {
      "prev": widget.prevEmotionsMeasure,
      "pos": widget.posEmotionsMeasure,
    };
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F9FF),
        body: SlidingUpPanel(
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
          panel: Text(""),
          body: Padding(
            padding: EdgeInsets.fromLTRB(0, height * .02, 0, height * .1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BasicCard(
                  height: height * .25,
                  width: width * .9,
                  child: MeasuresGraph(measures),
                ),
                SizedBox(
                  height: height * .2,
                  width: width * .9,
                  child: Column(
                    children: [
                      ResultsTitle(width),
                    ],
                  ),
                ),
                SizedBox(
                  height: width * .9 * (3 / 5),
                  width: width * .9,
                  child: Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: InkWell(
                            onTap: () {
                              navigationService.back();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue.withAlpha(150),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Icon(CupertinoIcons.back,
                                    size: width * .12, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Container(
                          child: Column(
                            children: [
                              Flexible(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.share,
                                          size: width * .07,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.purple,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.save,
                                          size: width * .05,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget ResultsTitle(double width) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text("Resultados"),
      Icon(
        CupertinoIcons.question_circle,
      )
    ],
  );
}

Widget summaryResults(EmotionsMeasure prevEmotionsMeasure,
    EmotionsMeasure posEmotionsMeasure, double width) {
  List<String> measures = EmotionsMeasure.measureNames;
  Map<String, IconData> iconsMap = EmotionsMeasure.iconsMap;

  return Column(
    children: measures
        .map((i) => singleResult(
            prevEmotionsMeasure.valuesMap[i] ?? 0,
            posEmotionsMeasure.valuesMap[i] ?? 0,
            iconsMap[i] ?? Icons.close,
            i))
        .toList(),
  );
}

Widget singleResult(double prev, double pos, IconData icon, String name) {
  return Row();
}
