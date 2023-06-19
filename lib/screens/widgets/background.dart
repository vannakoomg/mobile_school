import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              "assets/icons/login_icon/top1.png",
              width: size.width
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              "assets/icons/login_icon/top2.png",
              width: size.width
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: Image.asset(
              "assets/icons/login_icon/logo_no_background.png",
              width: size.width * 0.30
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/icons/login_icon/bottom1.png",
              width: size.width
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/icons/login_icon/bottom2.png",
              width: size.width
            ),
          ),
          child
        ],
      ),
    );
  }
}