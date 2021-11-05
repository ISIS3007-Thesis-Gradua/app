import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedGradientButton extends StatelessWidget {
  String? buttonText;
  final double width;
  final double height;
  final Function onPressed;
  double? fontSize;
  final Gradient gradient;
  Widget? child;

  RoundedGradientButton({
    required this.width,
    required this.height,
    required this.onPressed,
    required this.child,
    this.gradient = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFF8C2C8C), Color(0xFF0071BC)]),
  });

  RoundedGradientButton.text({
    required this.buttonText,
    required this.width,
    required this.height,
    required this.onPressed,
    this.fontSize = 18,
    this.gradient = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFF8C2C8C), Color(0xFF0071BC)]),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
        ],
        gradient: gradient,
        // LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   stops: [0.0, 1.0],
        //   colors: [
        //     Colors.deepPurple.shade400,
        //     Colors.deepPurple.shade200,
        //   ],
        // ),
        color: Colors.deepPurple.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          minimumSize: MaterialStateProperty.all(Size(width, height)),
          maximumSize: MaterialStateProperty.all(Size(width, height)),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          elevation: MaterialStateProperty.all(6),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
        ),
        onPressed: () {
          onPressed();
        },
        child: Padding(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
          child: child ??
              Text(
                buttonText!,
                style: GoogleFonts.raleway(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: fontSize ?? 18,
                  height: 1,
                ),
              ),
        ),
      ),
    );
  }
}
