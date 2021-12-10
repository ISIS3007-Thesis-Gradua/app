import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:serenity/src/views/home_view.dart';

import 'login_view.dart';

class AuthenticationWrapperView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    print("Build main wrapper");

    if (firebaseUser != null) {
      print("Home page");
      return const HomeView();
    } else {
      print("Welcome");
      return const Login();
    }
  }
}
