import 'package:flutter/material.dart';
import 'package:serenity/app/app.router.dart';
import 'package:serenity/src/views/home_view.dart';
import 'package:stacked_services/stacked_services.dart';

import 'settings/settings_controller.dart';

/// The Widget that configures your application.
class Serenity extends StatelessWidget {
  const Serenity({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: settingsController,
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
          themeMode: settingsController.themeMode,
          home: const HomeView(),

          // GraphView(
          //     EmotionsMeasure(emotion: 6.0, stress: 2.0, anxiety: 9.0),
          //     EmotionsMeasure(emotion: 3.0, stress: 8.0, anxiety: 0.0)),
          onGenerateRoute: StackedRouter().onGenerateRoute,
        );
      },
    );
  }
}
