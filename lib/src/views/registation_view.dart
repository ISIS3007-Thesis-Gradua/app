import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:serenity/src/view_models/registration_view_model.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

/// Creates an employee in te system.
class Registration extends StatefulWidget {
  const Registration({
    Key? key,
    required this.registrationViewModel,
  }) : super(key: key);
  final RegistrationViewModel registrationViewModel;
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
  bool _passwordInVisible = true;
  void _register() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrando usuario'),
        ),
      );
      await widget.registrationViewModel.registerUser();
      _btnController.success();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error registrando usuario'),
        ),
      );
      _btnController.error();
    }
    Timer(
      const Duration(seconds: 1),
      () {
        _btnController.reset();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Registrate en Gradua!'),
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
                          onChanged: widget.registrationViewModel.setName,
                          validator:
                              widget.registrationViewModel.importantValidator,
                          autovalidateMode: _autoValidateMode,
                        ),
                        //////
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Genero',
                          ),
                          value: widget.registrationViewModel.gender,
                          onChanged: widget.registrationViewModel.setGender,
                          items: widget.registrationViewModel.optionsGender,
                          autovalidateMode: _autoValidateMode,
                        ),
                        //////
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Correo Electronico',
                          ),
                          onChanged: widget.registrationViewModel.setEmail,
                          validator:
                              widget.registrationViewModel.emailValidator,
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
                          onChanged: widget.registrationViewModel.setPass,
                          validator: widget.registrationViewModel.passValidator,
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
                          onChanged:
                              widget.registrationViewModel.setConfirmPass,
                          validator:
                              widget.registrationViewModel.confirmPassValidator,
                          autovalidateMode: _autoValidateMode,
                        ),
                        RoundedLoadingButton(
                          child: const Text(
                            'Registrarse ahora!',
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
