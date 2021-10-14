enum MeditationGoals { Stress, Anxiety, Nothing }

class MeditationConfig {
  /// Time in minutes for the generated meditation.
  double time;

  /// Emotion levels between 0 and 1 where 0 is Sad and 1 is Happy.
  double emotion;

  /// The objective of the generated meditation.
  MeditationGoals goals;

  /// Emotion level between 0 and 10 where 0 is completely relaxed and
  /// 10 extremely stressed/anxious depending on the meditation goal.
  /// This Value won't be taken into account if the meditation goal is none.
  double goalLevels;

  MeditationConfig(
      {this.time = 5.0,
      this.emotion = 0,
      this.goals = MeditationGoals.Nothing,
      this.goalLevels = 5});
}
