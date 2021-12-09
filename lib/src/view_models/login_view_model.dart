import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The EmployeeUpdateController
/// uses the EmployeeUpdateService to store and retrieve user settings.
class LoginViewModel with ChangeNotifier {
  String _pass = "";
  String _email = "";
  // getters
  get email => _email;
  get pass => _pass;
  Future<void> setPass(String? newPass) async {
    if (newPass == null) return;

    // Dot not perform any work if new and old ThemeMode are identical
    if (_pass == newPass) return;
    // Otherwise, store the new theme mode in memory
    _pass = newPass;

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> setEmail(String? newEmail) async {
    if (newEmail == null) return;

    // Dot not perform any work if new and old ThemeMode are identical
    if (_email == newEmail) return;
    // Otherwise, store the new theme mode in memory
    _email = newEmail;

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> loginUser() async {
    try {
      SignInResult res = await Amplify.Auth.signIn(
        username: _email,
        password: _pass,
      );
      print(res.isSignedIn);
    } on AuthException catch (e) {
      print(e.message);
    }
  }
}
