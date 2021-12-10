import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:serenity/src/services/authentication_service.dart';
import 'package:serenity/src/utils/string_manipulation.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The EmployeeUpdateController
/// uses the EmployeeUpdateService to store and retrieve user settings.
class LoginViewModel with ChangeNotifier {
  String _pass = "";
  String _email = "";
  final AuthenticationService authenticationService;

  LoginViewModel(this.authenticationService);

  // getters
  get email => _email;
  get pass => _pass;
  Future<void> setPass(String? newPass) async {
    print('Set pass: $newPass');
    if (newPass == null) return;

    // Dot not perform any work if new and old ThemeMode are identical
    if (_pass == newPass) return;
    // Otherwise, store the new theme mode in memory
    _pass = newPass;
    print('Set ___pass: $_pass');

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> setEmail(String? newEmail) async {
    print('Set email: $newEmail');
    if (newEmail == null) return;

    // Dot not perform any work if new and old ThemeMode are identical
    if (_email == newEmail) return;
    // Otherwise, store the new theme mode in memory
    _email = newEmail;
    print('Set ___email: $_email');
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<AuthResult> loginUser() async {
    print("Login $email $pass");
    print("__ $_email $_pass");
    AuthResult res =
        await authenticationService.signIn(email: _email, password: _pass);
    // SignInResult res = await Amplify.Auth.signIn(
    //   username: _email,
    //   password: _pass,
    // );
    print(enumValue(res));
    return res;
  }
}
