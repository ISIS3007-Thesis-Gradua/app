//
// class NavigationService {
//   GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();
//
//   GlobalKey<NavigatorState> get navigationKey => _navigationKey;
//
//   void goBack() {
//     return _navigationKey.currentState!.pop();
//   }
//
//   Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
//     return _navigationKey.currentState!
//         .pushNamed(routeName, arguments: arguments);
//   }
//
//   void flushNavigator() {
//     _navigationKey.currentState!.popUntil(ModalRoute.withName('/'));
//   }
//
//   void printHello() {
//     print("Hello");
//   }
// }
