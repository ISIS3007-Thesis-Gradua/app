import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:serenity/src/services/authentication_service.dart';
import 'package:serenity/src/style/gradua_gradients.dart';

AppBar mainAppBar(BuildContext context) {
  AuthenticationService authenticationService =
      context.read<AuthenticationService>();
  return AppBar(
    // backgroundColor: Colors.white,
    backgroundColor: const Color(0xFF0071BC),
    // flexibleSpace: Container(
    //   decoration: BoxDecoration(
    //     gradient: GraduaGradients.helperTitleGradient.linearGradient,
    //   ),
    // ),
    actions: [
      IconButton(
        icon: const Icon(Icons.logout_rounded),
        onPressed: () => authenticationService.signOut(),
      ),
    ],
  );
}
