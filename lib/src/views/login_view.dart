import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:serenity/src/view_models/login_view_model.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

/// Creates an employee in te system.
class Login extends StatefulWidget {
  const Login({
    Key? key,
    required this.employeeId,
    required this.loginViewMode,
  }) : super(key: key);
  final LoginViewModel loginViewMode;
  final int employeeId;
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

  void _login() async {
    Timer(const Duration(seconds: 3), () {
      _btnController.success();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Ingresa a Gradua!'),
        ),
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
                          onChanged: widget.loginViewMode.setEmail,
                          autovalidateMode: _autoValidateMode,
                        ),
                        //////
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Contraseña',
                          ),
                          onChanged: widget.loginViewMode.setPass,
                          autovalidateMode: _autoValidateMode,
                        ),
                        /////
                        RoundedLoadingButton(
                          child: const Text(
                            'Ingresa!',
                            style: TextStyle(color: Colors.white),
                          ),
                          controller: _btnController,
                          onPressed: _login,
                        )
                      ],
                    )),
              ),
            ]),
          ),
        ));
  }
}
