import 'package:serenity/src/views/home_view.dart';
import 'package:serenity/src/views/player_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(routes: [
  CupertinoRoute(page: HomeView, initial: true),
  CupertinoRoute(page: Player, name: "player", path: "player")
], dependencies: [
  Singleton(classType: NavigationService)
])
class App {
  /** This class has no puporse besides housing the annotation that generates the required functionality **/
}
