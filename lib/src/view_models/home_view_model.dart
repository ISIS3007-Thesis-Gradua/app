import 'package:flutter/cupertino.dart';
import 'package:serenity/src/models/meditation.dart';
//
// class SimpleMeditation {
//   String name = "Generic Meditation";
//   Duration duration = Duration(seconds: 0);
//
//   SimpleMeditation({required this.name, required this.duration});
//
//   String formattedDuration() {
//     return "${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60))} mins";
//   }
// }

/// This class contains all the state and business logic for the
/// Home Screen. The Home screen will be bound to this class forming a sort
/// of MVVM architecture.
class HomeViewModel extends ChangeNotifier {
  /// List containing the saved Meditations that will be displayed on the
  /// home screen. TODO retrieve it from hive
  List<SimpleMeditation> savedMeditations = [];

  /// Basic contructor
  HomeViewModel(this.savedMeditations);

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
