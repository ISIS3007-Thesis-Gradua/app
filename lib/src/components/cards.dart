import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:serenity/src/style/gradua_gradients.dart';

///This class defines the basic card style for our design language
class BasicCard extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget child;
  final Gradient? gradient;
  const BasicCard(
      {Key? key, this.width, this.height, required this.child, this.gradient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFC5D2FA),
            spreadRadius: 0,
            blurRadius: 30,
            offset: Offset(5, 10), // changes position of shadow
          ),
          BoxShadow(
            color: Color(0xFFEBEFF3),
            spreadRadius: 1,
            blurRadius: 30,
            offset: Offset(-5, -10), // changes position of shadow
          ),
        ],
        gradient: gradient ?? GraduaGradients.basicCardGradient.linearGradient,
      ),
      child: child,
    );
  }
}
