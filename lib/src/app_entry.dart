import 'package:flutter/material.dart';
import 'package:serenity/amplifyconfiguration.dart';
import 'package:serenity/app/app.router.dart';
import 'package:serenity/src/view_models/login_view_model.dart';
import 'package:serenity/src/view_models/registration_view_model.dart';
import 'package:serenity/src/views/home_view.dart';
import 'package:serenity/src/views/login_view.dart';
import 'package:serenity/src/views/registation_view.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:serenity/src/settings/settings_controller.dart';
import 'dart:developer' as developer;

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
    await _configureAmplify();

    // after configuring Amplify, update loading ui state to loaded state
    setState(() {
      _isLoading = false;
    });
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
    return AnimatedBuilder(
      animation: widget.settingsController,
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          // restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          // localizationsDelegates: const [
          //   AppLocalizations.delegate,
          //   GlobalMaterialLocalizations.delegate,
          //   GlobalWidgetsLocalizations.delegate,
          //   GlobalCupertinoLocalizations.delegate,
          // ],
          // supportedLocales: const [
          //   Locale('en', ''), // English, no country code
          // ],
          //
          // // Use AppLocalizations to configure the correct application title
          // // depending on the user's locale.
          // //
          // // The appTitle is defined in .arb files found in the localization
          // // directory.
          // onGenerateTitle: (BuildContext context) =>
          //     AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: widget.settingsController.themeMode,
          home: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const HomeView(),
          // home: Registration(
          //   registrationViewModel: RegistrationViewModel(),
          // ),
          // home: Login(
          //   loginViewModel: LoginViewModel(),
          // ),
          // GraphView(
          //     EmotionsMeasure(emotion: 6.0, stress: 2.0, anxiety: 9.0),
          //     EmotionsMeasure(emotion: 3.0, stress: 8.0, anxiety: 0.0)),
          onGenerateRoute: StackedRouter().onGenerateRoute,
        );
      },
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
  try {
    await Amplify.configure(amplifyconfig);
  } on AmplifyAlreadyConfiguredException catch (e) {
    developer.log(
      'Error at Amplify: ${e.message}, Suggetion: ${e.recoverySuggestion}, Under: ${e.underlyingException}',
    );
  }
}
