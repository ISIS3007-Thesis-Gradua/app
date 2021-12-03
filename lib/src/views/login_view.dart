import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:serenity/app/app.locator.dart';
import 'package:serenity/app/app.router.dart';
import 'package:serenity/src/view_models/login_view_model.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:stacked_services/stacked_services.dart';

/// Creates an employee in te system.
class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class _LoginState extends State<Login> {
  // final init
  final _formKey = GlobalKey<FormState>();
  final AutovalidateMode _autoValidateMode = AutovalidateMode.onUserInteraction;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final LoginViewModel _loginViewModel = LoginViewModel();
  late final NavigationService navigationService;

  @override
  void initState() {
    navigationService = locator<NavigationService>();
    super.initState();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      //await _loginViewModel.loginUser();
      _btnController.success();
      navigationService.clearTillFirstAndShow(
        Routes.homeView,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Autenticacion completa'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al autenticar'),
        ),
      );
      _btnController.error();
    }
    Timer(
      const Duration(seconds: 2),
      () {
        _btnController.reset();
      },
    );
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
                    //////
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Correo Electronico',
                      ),
                      onChanged: _loginViewModel.setEmail,
                      autovalidateMode: _autoValidateMode,
                    ),
                    //////
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                      ),
                      onChanged: _loginViewModel.setPass,
                      autovalidateMode: _autoValidateMode,
                    ),
                    /////
                    RoundedLoadingButton(
                      child: const Text(
                        'Ingresar',
                        style: TextStyle(color: Colors.white),
                      ),
                      controller: _btnController,
                      onPressed: _login,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Si no tienes una cuenta ',
                        style: const TextStyle(fontSize: 20),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Registrate aqui!',
                            style: const TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => {
                                    navigationService.navigateTo(
                                      Routes.registration,
                                    ),
                                  },
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
