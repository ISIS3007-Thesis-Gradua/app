import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';

GetIt locator = GetIt.instance;

class DialogService {
  final navigationService = locator<NavigationService>();
  DialogService();

  Future showMeditationRatingDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title:
                Text("You need internet connection to get a Quick Meditation."),
            content: Text("Please check your internet connection settings."),
            actions: [
              TextButton(
                onPressed: () => navigationService.back(),
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.blue),
                ),
              )
            ],
          );
        });
  }
}
