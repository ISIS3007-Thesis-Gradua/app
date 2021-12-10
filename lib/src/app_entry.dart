import 'dart:developer' as developer;

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serenity/amplifyconfiguration.dart';
import 'package:serenity/app/app.router.dart';
import 'package:serenity/src/services/authentication_service.dart';
import 'package:serenity/src/settings/settings_controller.dart';
import 'package:serenity/src/views/authentication_wrapper_view.dart';
import 'package:stacked_services/stacked_services.dart';

/// The Widget that configures your application.
class Serenity extends StatefulWidget {
  const Serenity({
    Key? key,
    required this.settingsController,
  }) : super(key: key);
  final SettingsController settingsController;
  @override
  _SerenityState createState() => _SerenityState();
}

class _SerenityState extends State<Serenity> {
  bool _isLoading = true;
  Future<void> _initializeApp() async {
    // configure Amplify
    try {
      await _configureAmplify();
    } on AmplifyAlreadyConfiguredException catch (e) {
      developer.log(
        'Error at Amplify: ${e.message}, Suggetion: ${e.recoverySuggestion}, Under: ${e.underlyingException}',
      );
    }
    setState(() {
      _isLoading = false;
    });
    // after configuring Amplify, update loading ui state to loaded state
  }

  @override
  initState() {
    super.initState();
    _initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          initialData: null,
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
        ),
      ],
      child: AnimatedBuilder(
        animation: widget.settingsController,
        builder: (BuildContext context, Widget? child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(),
            darkTheme: ThemeData.dark(),
            themeMode: widget.settingsController.themeMode,
            home: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : AuthenticationWrapperView(),
            // home: Registration(
            //   registrationViewModel: RegistrationViewModel(),
            // ),
            onGenerateRoute: StackedRouter().onGenerateRoute,
          );
        },
      ),
    );
  }
}

Future<void> _configureAmplify() async {
  // Add Pinpoint and Cognito Plugins, or any other plugins you want to use

  await Amplify.addPlugins(
    [
      AmplifyAuthCognito(),
      AmplifyAPI(),
    ],
  );

  // Once Plugins are added, configure Amplify
  // Note: Amplify can only be configured once.
  return Amplify.configure(amplifyconfig);
}
