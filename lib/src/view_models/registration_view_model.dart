import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The EmployeeUpdateController
/// uses the EmployeeUpdateService to store and retrieve user settings.
class RegistrationViewModel with ChangeNotifier {
  String _gender = "No especifica";
  String _name = "";
  String _pass = "";
  String _confirmPass = "";
  String _email = "";

  // validators
  get importantValidator => MultiValidator([
        RequiredValidator(errorText: 'input required'),
        MaxLengthValidator(20,
            errorText: 'maximun length allowed is 20 characters'),
        PatternValidator(r'^[0-9a-zA-Z\-]*$',
            errorText: 'only alphanumeric characters allowed')
      ]);

  get passValidator => MultiValidator([
        RequiredValidator(errorText: 'password is required'),
        MinLengthValidator(8,
            errorText: 'password must be at least 8 digits long'),
        PatternValidator(r'(?=.*?[#?!@$%^&*-])',
            errorText: 'passwords must have at least one special character'),
      ]);

  String confirmPassValidator(val) {
    String validate = MatchValidator(errorText: 'passwords do not match')
        .validateMatch(val, _pass)!;
    return validate;
  }

  // getters
  get gender => _gender;
  get name => _name;
  get pass => _pass;
  get confirmPass => _confirmPass;
  get email => _email;

  //
  List<DropdownMenuItem<String>> get optionsGender =>
      ["Masculino", "Femenino", "No especifica"].map(
        (String gender) {
          return DropdownMenuItem<String>(value: gender, child: Text(gender));
        },
      ).toList();

  // setters
  Future<void> setGender(String? newName) async {
    if (newName == null) return;

    // Dot not perform any work if new and old ThemeMode are identical
    if (newName == _name) return;
    // Otherwise, store the new theme mode in memory
    _name = newName;

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> setName(String? newGender) async {
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
}
