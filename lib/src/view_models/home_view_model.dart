import 'package:flutter/cupertino.dart';
import 'package:serenity/src/models/meditation.dart';
import 'package:serenity/src/models/meditation_config.dart';

/// This class contains all the state and business logic for the
/// Home Screen. The Home screen will be bound to this class forming a sort
/// of MVVM architecture.
class HomeViewModel extends ChangeNotifier {
  /// List containing the saved Meditations that will be displayed on the
  /// home screen. TODO retrieve it from hive
  List<SimpleMeditation> savedMeditations = [];

  /// Configuration Values for the generated meditation
  MeditationConfig meditationConfig = MeditationConfig();

  /// Basic contructor
  HomeViewModel({required this.savedMeditations});

  /// This creates a list of meditations with some default example data
  HomeViewModel.exampleData() {
    savedMeditations = [
      SimpleMeditation(
        name: "Meditation for Stress",
        duration: Duration(seconds: 150),
      ),
      SimpleMeditation(
        name: "Meditation for Anxiety",
        duration: Duration(seconds: 150),
      ),
      SimpleMeditation(
        name: "Traditional chinese meditation",
        duration: Duration(seconds: 150),
      ),
      SimpleMeditation(
        name: "Mindfulness basics",
        duration: Duration(seconds: 150),
      ),
      SimpleMeditation(
        name: "Mindfulness advanced",
        duration: Duration(seconds: 150),
      ),
    ];
  }
}
