import 'package:flutter/material.dart';

class CustomCardTitle extends StatelessWidget {
  final String? title;
  final String? descrtion;
  const CustomCardTitle(
      {Key? key, required this.descrtion, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "$title",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 40),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "$descrtion",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 30),
        )
      ],
    );
  }
}
