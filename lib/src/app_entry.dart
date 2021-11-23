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
          debugShowCheckedModeBanner: false,
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
