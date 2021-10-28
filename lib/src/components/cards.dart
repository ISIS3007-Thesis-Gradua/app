import 'package:flutter/cupertino.dart';

///This class defines the basic card style for our design language
class BasicCard extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget child;
  const BasicCard({Key? key, this.width, this.height, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
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
        gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xA3A6D5FF),
              Color(0xFFC9E0FF),
              Color(0xFFE2EFFD),
            ],
            stops: [
              0,
              0.5,
              0.9
            ]),
      ),
      child: child,
    );
  }
}
