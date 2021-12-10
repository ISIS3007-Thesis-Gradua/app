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
import 'package:serenity/src/style/text_theme.dart';
import 'package:serenity/src/view_models/login_view_model.dart';
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
  LoginViewModel? _loginViewModel;
  late final NavigationService navigationService;

  @override
  void initState() {
    navigationService = locator<NavigationService>();
    super.initState();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      //await _loginViewModel.loginUser();
      // navigationService.clearTillFirstAndShow(
      //   Routes.homeView,
      // );
      print('[Login info] ${_loginViewModel!.email} ${_loginViewModel!.pass}');
      AuthResult res = await _loginViewModel!.loginUser();

      if (res == AuthResult.signedIn) {
        _btnController.success();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Autenticacion completa'),
          ),
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al autenticar'),
        ),
      );
      _btnController.error();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Campos erroneos'),
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
    if (_loginViewModel == null) {
      AuthenticationService authenticationService =
          context.read<AuthenticationService>();
      _loginViewModel = LoginViewModel(authenticationService);
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
          child: Form(
              key: _formKey,
              child: SizedBox(
                width: double.infinity,
                height: height,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * .1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: height * .1),
                        child: Image.asset(
                          "assets/images/key.png",
                          height: height * .15,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, height * .015),
                        child: GradientText(
                          "¡Bienvenido a Gradúa!",
                          style: titleStyle,
                          align: TextAlign.center,
                        ),
                      ),
                      Text(
                        "Tu asistente meditador\na la mano.",
                        style: subtitleStyle,
                        textAlign: TextAlign.center,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Correo Electronico',
                        ),
                        onChanged: _loginViewModel!.setEmail,
                        autovalidateMode: _autoValidateMode,
                      ),
                      //////
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Contraseña',
                        ),
                        onChanged: _loginViewModel!.setPass,
                        autovalidateMode: _autoValidateMode,
                      ),
                      /////
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, height * .02, 0, 0),
                        child: RoundedLoadingButton(
                          child: const Text(
                            'Ingresar',
                            style: TextStyle(color: Colors.white),
                          ),
                          controller: _btnController,
                          onPressed: _login,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, height * .02),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Si no tienes una cuenta  ',
                            style: subtitleStyle,
                            children: <TextSpan>[
                              TextSpan(
                                text: '¡Registrate aqui!',
                                style: const TextStyle(
                                    color: Colors.deepPurpleAccent),
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
                      ),
                    ],
                  ),
                ),
              )),
        ));
  }
}
