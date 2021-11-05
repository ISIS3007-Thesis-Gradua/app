import 'package:serenity/src/models/emotions_measure.dart';
import 'package:serenity/src/models/meditation_config.dart';

class SimpleMeditation {
  String name;
  Duration duration;

  SimpleMeditation(
      {this.name = "Generated Meditation", this.duration = Duration.zero});

  String formattedDuration() {
    return "${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60))} mins";
  }
}

class Meditation extends SimpleMeditation {
  String id = '';
  String? url;
  String meditationText = '';
  MeditationConfig config = MeditationConfig();

  Meditation.blank() : super();

  Meditation(
      {this.id = '',
      this.url,
      required this.meditationText,
      required this.config})
      : super();

  EmotionsMeasure getEmotionMeasure() {
    return EmotionsMeasure(
        emotion: config.emotion,
        stress: config.stress,
        anxiety: config.anxiety);
  }
}
