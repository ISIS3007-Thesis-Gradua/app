///This class represents a general measurements of the user's emotional state
/// We will have an instance of this class prior to the meditation (provided
/// by the MeditationConfig instance), and another intstance after the meditation.
class EmotionsMeasure {
  /// Emotion levels between 0 and 1 where 0 is Sad and 1 is Happy.
  double emotion;

  /// Stress levels between 0 and 10 where 0 is completely calmed and 10
  /// is extremely stressed.
  double stress;

  /// Stress levels between 0 and 10 where 0 is relaxed calmed and 10
  /// is extremely stressed.
  double anxiety;

  EmotionsMeasure(
      {required this.emotion, required this.stress, required this.anxiety});

  EmotionsMeasure.blank({this.emotion = 0, this.stress = 0, this.anxiety = 0});
}
