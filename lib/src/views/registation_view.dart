import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:serenity/app/app.locator.dart';
import 'package:serenity/app/app.router.dart';
import 'package:serenity/src/view_models/registration_view_model.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:stacked_services/stacked_services.dart';

/// Creates an employee in te system.
class Registration extends StatefulWidget {
  const Registration({
    Key? key,
  }) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class _RegistrationState extends State<Registration> {
  // final init
  final _formKey = GlobalKey<FormState>();
  final AutovalidateMode _autoValidateMode = AutovalidateMode.onUserInteraction;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  late final NavigationService navigationService;
  bool _passwordInVisible = true;
  final RegistrationViewModel _registrationViewModel = RegistrationViewModel();

  @override
  void initState() {
    navigationService = locator<NavigationService>();
    super.initState();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrando usuario'),
        ),
      );
      await _registrationViewModel.registerUser();
      _btnController.success();
      Timer(const Duration(seconds: 2), () {
        navigationService.back();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error registrando usuario'),
        ),
      );
      _btnController.error();
      Timer(
        const Duration(seconds: 2),
        () {
          _btnController.reset();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16),
      // Glue the SettingsController to the theme selection DropdownButton.
      //
      // When a user selects a theme from the dropdown list, the
      // SettingsController is updated, which rebuilds the MaterialApp.
      child: SingleChildScrollView(
        child: Stack(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                      ),
                      onChanged: _registrationViewModel.setName,
                      validator: _registrationViewModel.importantValidator,
                      autovalidateMode: _autoValidateMode,
                    ),
                    //////
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Genero',
                      ),
                      value: _registrationViewModel.gender,
                      onChanged: _registrationViewModel.setGender,
                      items: _registrationViewModel.optionsGender,
                      autovalidateMode: _autoValidateMode,
                    ),
                    //////
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Correo Electronico',
                      ),
                      onChanged: _registrationViewModel.setEmail,
                      validator: _registrationViewModel.emailValidator,
                      autovalidateMode: _autoValidateMode,
                    ),
                    //////
                    TextFormField(
                      obscureText: _passwordInVisible,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordInVisible
                                ? Icons.visibility_off
                                : Icons
                                    .visibility, //change icon based on boolean value
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordInVisible =
                                  !_passwordInVisible; //change boolean value
                            });
                          },
                        ),
                      ),
                      onChanged: _registrationViewModel.setPass,
                      validator: _registrationViewModel.passValidator,
                      autovalidateMode: _autoValidateMode,
                    ),
                    //////
                    TextFormField(
                      obscureText: _passwordInVisible,
                      decoration: InputDecoration(
                        labelText: 'Confirmar Contraseña',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordInVisible
                                ? Icons.visibility_off
                                : Icons
                                    .visibility, //change icon based on boolean value
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordInVisible =
                                  !_passwordInVisible; //change boolean value
                            });
                          },
                        ),
                      ),
                      onChanged: _registrationViewModel.setConfirmPass,
                      validator: _registrationViewModel.confirmPassValidator,
                      autovalidateMode: _autoValidateMode,
                    ),
                    RoundedLoadingButton(
                      child: const Text(
                        'Registrarse ahora!',
                        style: TextStyle(color: Colors.white),
                      ),
                      controller: _btnController,
                      onPressed: _register,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Si no tienes una cuenta',
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Registrate aqui!',
                            style: const TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () =>
                                  navigationService.navigateTo(Routes.register),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ]),
      ),
    ));
  }
}
