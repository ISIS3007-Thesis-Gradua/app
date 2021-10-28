import 'package:flutter/cupertino.dart';
import 'package:serenity/src/models/emotions_measure.dart';

class MeditationRatingViewModel extends ChangeNotifier {
  EmotionsMeasure posEmotions = EmotionsMeasure.blank();
  late EmotionsMeasure prevEmotionsMeasure;

  MeditationRatingViewModel();

  void init(EmotionsMeasure prevEmotionsMeasure) {
    this.prevEmotionsMeasure = prevEmotionsMeasure;
  }

  void setPosEmotion(double emotion) {
    posEmotions.emotion = emotion;
    notifyListeners();
  }
}
