import 'package:serenity/src/models/emotions_measure.dart';
import 'package:serenity/src/models/meditation_config.dart';
import 'package:serenity/src/utils/string_manipulation.dart';
//TODO better model this thing

class SimpleMeditation {
  String name;
  Duration duration;

  SimpleMeditation(
      {this.name = "Generated Meditation", this.duration = Duration.zero});

  String formattedDuration() {
    return "${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60))} mins";
  }
}

class Step {
  String id;
  String cleanText;
  String rawText;

  Step(this.id, this.cleanText, this.rawText);
}

class Meditation extends SimpleMeditation {
  String id = '';
  String? url;
  String meditationText = '';
  MeditationConfig config = MeditationConfig();
  List<Step> steps = [];

  Meditation.blank() : super();

  Meditation(
      {this.id = '',
      this.url,
      this.steps = const [],
      required this.meditationText,
      required this.config})
      : super();

  EmotionsMeasure getEmotionMeasure() {
    return EmotionsMeasure(
        emotion: config.emotion,
        stress: config.stress,
        anxiety: config.anxiety);
  }

  factory Meditation.fromRawJson(
      Map<String, dynamic> json, MeditationConfig config) {
    String meditationText = "";
    List<Step> steps = [];

    // print("CLEAN DATA");
    json.forEach((stepName, value) {
      if (value is List && value.isNotEmpty) {
        String id =
            value[0]["_id"] is String ? (value[0]["_id"] as String) : "";
        String content = value[0]["content"] is String
            ? (value[0]["content"] as String)
            : "";
        String cleanContent = sanitizeTtsText(content);
        steps.add(Step(id, cleanContent, content));
        meditationText += " " + cleanContent;
      }
    });

    // print(meditationText);

    return Meditation(
        meditationText: meditationText,
        config: config,
        steps: steps,
        url:
            "https://188s5h8465.execute-api.us-east-1.amazonaws.com/dev/randomize?");
  }
}
