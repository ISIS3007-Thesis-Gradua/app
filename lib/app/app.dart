import 'package:serenity/src/services/navigation_service.dart';
import 'package:serenity/src/views/home_view.dart';
import 'package:stacked/stacked_annotations.dart';

@StackedApp(
    routes: [CupertinoRoute(page: HomeView, initial: true)],
    dependencies: [Singleton(classType: NavigationService)])
class App {
  /** This class has no puporse besides housing the annotation that generates the required functionality **/
}
