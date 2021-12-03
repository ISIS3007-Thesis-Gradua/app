import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'dart:developer' as developer;

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The EmployeeUpdateController
/// uses the EmployeeUpdateService to store and retrieve user settings.
class RegistrationViewModel with ChangeNotifier {
  String _gender = "Otro";
  String _name = "";
  String _pass = "";
  String _confirmPass = "";
  String _email = "";

  // validators
  final importantValidator = MultiValidator([
    RequiredValidator(errorText: 'Entrada requerida'),
    MaxLengthValidator(20, errorText: 'La longitud maxima son 20 caracteres'),
    PatternValidator(r'^[0-9a-zA-Z\-]*$',
        errorText: 'Solo caracteres Alfanumericos permitidos')
  ]);
  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Entrada requerida'),
    EmailValidator(errorText: 'Ingrese un Email valido'),
  ]);
  final passValidator = MultiValidator([
    RequiredValidator(errorText: 'Entrada requerida'),
    MinLengthValidator(8, errorText: 'La longitud minima es de 8 caracteres'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'La contraseña debe tener por lo menos un caracter especial')
  ]);

  String? confirmPassValidator(val) {
    return MatchValidator(errorText: 'Las contraseñas coinciden')
        .validateMatch(val, _pass);
  }

  // getters
  get gender => _gender;
  get name => _name;
  get pass => _pass;
  get confirmPass => _confirmPass;
  get email => _email;

  //
  List<DropdownMenuItem<String>> get optionsGender =>
      ["Masculino", "Femenino", "Otro"].map(
        (String gender) {
          return DropdownMenuItem<String>(value: gender, child: Text(gender));
        },
      ).toList();

  // setters
  Future<void> setName(String? newName) async {
    if (newName == null) return;

    // Dot not perform any work if new and old ThemeMode are identical
    if (newName == _name) return;
    // Otherwise, store the new theme mode in memory
    _name = newName;

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> setGender(String? newGender) async {
    if (newGender == null) return;

    // Dot not perform any work if new and old ThemeMode are identical
    if (newGender == _gender) return;
    // Otherwise, store the new theme mode in memory
    _gender = newGender;

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> setPass(String? newPass) async {
    if (newPass == null) return;

    // Dot not perform any work if new and old ThemeMode are identical
    if (_pass == newPass) return;
    // Otherwise, store the new theme mode in memory
    _pass = newPass;

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> setConfirmPass(String? newConfirmPass) async {
    if (newConfirmPass == null) return;

    // Dot not perform any work if new and old ThemeMode are identical
    if (_confirmPass == newConfirmPass) return;
    // Otherwise, store the new theme mode in memory
    _confirmPass = newConfirmPass;

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

  Future<void> registerUser() async {
    try {
      Map<String, String> userAttributes = {
        'gender': _gender,
        'name': _name,
        'email': _email,
        // additional attributes as needed
      };
      SignUpResult res = await Amplify.Auth.signUp(
          username: _email,
          password: _pass,
          options: CognitoSignUpOptions(userAttributes: userAttributes));
      developer.log(
        '${res.isSignUpComplete}',
      );
      print(res.isSignUpComplete);
    } on AuthException catch (e) {
      developer.log(
        'Error at Amplify: ${e.message}, Suggetion: ${e.recoverySuggestion}, Under: ${e.underlyingException}',
      );
    }
  }
}
