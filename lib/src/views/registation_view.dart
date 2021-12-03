import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:serenity/src/view_models/registration_view_model.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

/// Creates an employee in te system.
class Registration extends StatefulWidget {
  const Registration({
    Key? key,
    required this.employeeId,
    required this.registrationViewMode,
  }) : super(key: key);
  final RegistrationViewModel registrationViewMode;
  final int employeeId;
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

  void _register() async {
    Timer(const Duration(seconds: 3), () {
      _btnController.success();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Crea una nueva cuenta'),
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
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Nombre',
                          ),
                          onChanged: widget.registrationViewMode.setName,
                          validator:
                              widget.registrationViewMode.importantValidator,
                          autovalidateMode: _autoValidateMode,
                        ),
                        //////
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Genero',
                          ),
                          value: widget.registrationViewMode.gender,
                          onChanged: widget.registrationViewMode.setGender,
                          items: widget.registrationViewMode.optionsGender,
                          autovalidateMode: _autoValidateMode,
                        ),
                        //////
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Correo Electronico',
                          ),
                          onChanged: widget.registrationViewMode.setEmail,
                          validator:
                              widget.registrationViewMode.importantValidator,
                          autovalidateMode: _autoValidateMode,
                        ),
                        //////
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Contraseña',
                          ),
                          onChanged: widget.registrationViewMode.setPass,
                          validator: widget.registrationViewMode.passValidator,
                          autovalidateMode: _autoValidateMode,
                        ),
                        //////
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Confirmar Contraseña',
                          ),
                          onChanged: widget.registrationViewMode.setConfirmPass,
                          validator:
                              widget.registrationViewMode.confirmPassValidator,
                          autovalidateMode: _autoValidateMode,
                        ),
                        RoundedLoadingButton(
                          child: const Text(
                            'Registrate!',
                            style: TextStyle(color: Colors.white),
                          ),
                          controller: _btnController,
                          onPressed: _register,
                        )
                      ],
                    )),
              ),
            ]),
          ),
        ));
  }
}
