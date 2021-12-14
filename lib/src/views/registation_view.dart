import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:serenity/app/app.locator.dart';
import 'package:serenity/app/app.router.dart';
import 'package:serenity/src/services/authentication_service.dart';
import 'package:serenity/src/services/firestore_service.dart';
import 'package:serenity/src/style/text_theme.dart';
import 'package:serenity/src/view_models/registration_view_model.dart';
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
  RegistrationViewModel? _registrationViewModel;

  @override
  void initState() {
    navigationService = locator<NavigationService>();
    var fireStoreService = locator<FireStoreService>();

    super.initState();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      await _registrationViewModel!.registerUser();
      _btnController.success();
      Timer(const Duration(milliseconds: 500), () {
        navigationService.back();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuario Registrado Exitosamente'),
        ),
      );
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
    if (_registrationViewModel == null) {
      AuthenticationService authenticationService =
          context.read<AuthenticationService>();
      _registrationViewModel = RegistrationViewModel(authenticationService);
    }

    double getHeight() {
      return MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom;
    }

    final double height = getHeight();
    final width = MediaQuery.of(context).size.width;

    TextStyle titleStyle = GoogleFonts.raleway(
      color: Colors.black87,
      fontWeight: FontWeight.w700,
      fontSize: height * .026,
    );

    TextStyle subtitleStyle = titleStyle.copyWith(
      fontWeight: FontWeight.w300,
      fontSize: height * .016,
      color: Colors.black45,
      height: height * .001,
    );

    return Scaffold(
        backgroundColor: const Color(0xFFF6F9FF),
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            height: height,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * .1),
              child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: height * .1),
                        child: Image.asset(
                          "assets/images/password.png",
                          height: height * .15,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, height * .015),
                        child: GradientText(
                          "Registrate",
                          style: titleStyle,
                          align: TextAlign.center,
                        ),
                      ),

                      Text(
                        "Crea una cuenta para continuar.",
                        style: subtitleStyle,
                        textAlign: TextAlign.center,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                        ),
                        onChanged: _registrationViewModel!.setName,
                        validator: _registrationViewModel!.importantValidator,
                        autovalidateMode: _autoValidateMode,
                      ),
                      //////
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Genero',
                        ),
                        value: _registrationViewModel!.gender,
                        onChanged: _registrationViewModel!.setGender,
                        items: _registrationViewModel!.genders.map(
                          (String gender) {
                            return DropdownMenuItem<String>(
                                value: gender, child: Text(gender));
                          },
                        ).toList(),
                        validator: _registrationViewModel!.genderValidator,
                        autovalidateMode: _autoValidateMode,
                      ),
                      //////
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Correo Electronico',
                        ),
                        onChanged: _registrationViewModel!.setEmail,
                        validator: _registrationViewModel!.emailValidator,
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
                              color: Colors.purpleAccent,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordInVisible =
                                    !_passwordInVisible; //change boolean value
                              });
                            },
                          ),
                        ),
                        onChanged: _registrationViewModel!.setPass,
                        validator: _registrationViewModel!.passValidator,
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
                              color: Colors.purpleAccent,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordInVisible =
                                    !_passwordInVisible; //change boolean value
                              });
                            },
                          ),
                        ),
                        onChanged: _registrationViewModel!.setConfirmPass,
                        validator: _registrationViewModel!.confirmPassValidator,
                        autovalidateMode: _autoValidateMode,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, height * .05, 0, 0),
                        child: RoundedLoadingButton(
                          child: const Text(
                            'Registrarse',
                            style: TextStyle(color: Colors.white),
                          ),
                          controller: _btnController,
                          onPressed: _register,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, height * .02),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Si ya tienes una cuenta  ',
                            style: subtitleStyle,
                            children: <TextSpan>[
                              TextSpan(
                                text: '¡Ingresa aqui!',
                                style: const TextStyle(
                                    color: Colors.deepPurpleAccent),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => {
                                        navigationService.navigateTo(
                                          Routes.login,
                                        ),
                                      },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ));
  }
}
