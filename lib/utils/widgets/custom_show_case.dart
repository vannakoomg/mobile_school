import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class CustomShowCase extends StatelessWidget {
  final Widget child;
  final String title;
  final GlobalKey key1;
  const CustomShowCase({
    Key? key,
    required this.child,
    required this.title,
    required this.key1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Showcase(
      targetBorderRadius: BorderRadius.circular(200),
      targetPadding: EdgeInsets.all(5),
      tooltipBackgroundColor: Colors.white.withOpacity(1),
      key: key1,
      description: title,
      child: child,
    );
  }
}
