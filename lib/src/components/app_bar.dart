import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:serenity/src/services/authentication_service.dart';

AppBar mainAppBar(BuildContext context) {
  AuthenticationService authenticationService =
      context.read<AuthenticationService>();
  return AppBar(
    backgroundColor: const Color(0xFF0071BC).withAlpha(200),
    actions: [
      IconButton(
        icon: const Icon(Icons.logout_rounded),
        onPressed: () => authenticationService.signOut(),
      ),
    ],
  );
}
