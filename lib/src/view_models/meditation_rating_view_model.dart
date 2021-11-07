import 'package:flutter/cupertino.dart';
import 'package:serenity/src/models/emotions_measure.dart';

///Handles the state fo the MeditationRatingView Statefull Widget.
class MeditationRatingViewModel extends ChangeNotifier {
  ///Emotions measure after meditating
  EmotionsMeasure posEmotions = EmotionsMeasure.blank();

  ///Emotions measure before meditating
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
