import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:serenity/app/app.locator.dart';

import 'firebase_options.dart';
import 'src/app_entry.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  //Initialize the singletons described in the app/app.locator.dart file
  setupLocator();

  WidgetsFlutterBinding.ensureInitialized();
  //Initialize firebase Core servcies
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(Serenity(settingsController: settingsController));
}
