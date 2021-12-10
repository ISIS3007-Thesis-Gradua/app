import 'package:serenity/src/models/emotions_measure.dart';

class MeditationConfig {
  /// Time in minutes for the generated meditation.
  double time;

  /// Emotion levels between 0 and 1 where 0 is Sad and 1 is Happy.
  double emotion;

  /// Stress levels between 0 and 10 where 0 is completely calmed and 10
  /// is extremely stressed.
  double stress;

  /// Stress levels between 0 and 10 where 0 is relaxed calmed and 10
  /// is extremely stressed.
  double anxiety;

  /// Emotion level between 0 and 10 where 0 is completely relaxed and
  /// 10 extremely stressed/anxious depending on the meditation goal.
  /// This Value won't be taken into account if the meditation goal is none.
  double goalLevels;

  MeditationConfig(
      {this.time = 6.0,
      this.emotion = 0,
      this.stress = 0,
      this.anxiety = 0,
      this.goalLevels = 5});

  ///This getter provides the information about the user's emotional state
  ///at the time of the configuration of the meditation.
  EmotionsMeasure get emotionsMeasure {
    return EmotionsMeasure(emotion: emotion, stress: stress, anxiety: anxiety);
  }
}
