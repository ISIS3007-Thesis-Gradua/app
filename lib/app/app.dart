import 'package:serenity/src/views/home_view.dart';
import 'package:serenity/src/views/loading_meditation.dart';
import 'package:serenity/src/views/other_player.dart';
import 'package:serenity/src/views/player_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(routes: [
  CupertinoRoute(page: HomeView, initial: true),
  CupertinoRoute(page: Player, name: "player", path: "player"),
  CupertinoRoute(page: OtherPlayer, name: "other_player", path: "other_player"),
  CupertinoRoute(
      page: LoadingMeditationView,
      name: "loading_meditation",
      path: "loading_meditation")
], dependencies: [
  Singleton(classType: NavigationService),
  Singleton(classType: DialogService)
])
class App {
  /** This class has no puporse besides housing the annotation that generates the required functionality **/
}
