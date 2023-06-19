import 'package:flutter/material.dart';

class MyTextStyle extends TextStyle {
  final Color color;
  final FontWeight fontWeight;
  final double size;
  final FontStyle fontStyle;
  // final String fontFamily;

  const MyTextStyle({
    required this.color,
    required this.fontWeight,
    required this.size,
    this.fontStyle = FontStyle.normal,
    // this.fontFamily = 'Montserrat',
  }) : super(
          color: color,
          fontWeight: fontWeight,
          fontSize: size,
          // fontStyle: FontStyle.normal
          // fontFamily: fontFamily,
        );
}

enum PhoneSize { iphone, ipad }

const Map<PhoneSize, MyTextStyle> myTextStyleHeaderBigSize = {
  PhoneSize.ipad: MyTextStyle(
      color: Color(0xff1d1a56), fontWeight: FontWeight.bold, size: 20),
  PhoneSize.iphone: MyTextStyle(
      color: Color(0xff1d1a56), fontWeight: FontWeight.bold, size: 16),
};

const Map<PhoneSize, MyTextStyle> myTextStyleHeader = {
  PhoneSize.ipad: MyTextStyle(
      color: Color(0xff1d1a56), fontWeight: FontWeight.bold, size: 18),
  PhoneSize.iphone: MyTextStyle(
      color: Color(0xff1d1a56), fontWeight: FontWeight.bold, size: 14),
};

const Map<PhoneSize, MyTextStyle> myTextStyleHeaderRed = {
  PhoneSize.ipad:
      MyTextStyle(color: Colors.red, fontWeight: FontWeight.bold, size: 18),
  PhoneSize.iphone:
      MyTextStyle(color: Colors.red, fontWeight: FontWeight.bold, size: 14),
};

const Map<PhoneSize, MyTextStyle> myTextStyleBody = {
  PhoneSize.ipad:
      MyTextStyle(color: Colors.black, fontWeight: FontWeight.normal, size: 18),
  PhoneSize.iphone:
      MyTextStyle(color: Colors.black, fontWeight: FontWeight.normal, size: 14),
};

const Map<PhoneSize, MyTextStyle> myTextStyleHeaderWhite = {
  PhoneSize.ipad:
      MyTextStyle(color: Colors.white, fontWeight: FontWeight.bold, size: 18),
  PhoneSize.iphone:
      MyTextStyle(color: Colors.white, fontWeight: FontWeight.bold, size: 14),
};

const Map<PhoneSize, MyTextStyle> myTextStyleBodyWhite = {
  PhoneSize.ipad:
      MyTextStyle(color: Colors.white, fontWeight: FontWeight.normal, size: 18),
  PhoneSize.iphone:
      MyTextStyle(color: Colors.white, fontWeight: FontWeight.normal, size: 14),
};

const Map<PhoneSize, MyTextStyle> myTextStyleBodyBlueGray = {
  PhoneSize.ipad: MyTextStyle(
      color: Color(0xff778ba3), fontWeight: FontWeight.bold, size: 18),
  PhoneSize.iphone: MyTextStyle(
      color: Color(0xff778ba3), fontWeight: FontWeight.bold, size: 14),
};

const Map<PhoneSize, MyTextStyle> myTextStyleHeaderAmberAccent = {
  PhoneSize.ipad: MyTextStyle(
      color: Colors.amberAccent, fontWeight: FontWeight.bold, size: 18),
  PhoneSize.iphone: MyTextStyle(
      color: Colors.amberAccent, fontWeight: FontWeight.bold, size: 14),
};

const Map<PhoneSize, MyTextStyle> myTextStyleBodyBlue = {
  PhoneSize.ipad: MyTextStyle(
      color: Colors.blueAccent, fontWeight: FontWeight.normal, size: 18),
  PhoneSize.iphone: MyTextStyle(
      color: Colors.blueAccent, fontWeight: FontWeight.normal, size: 14),
};

const Map<PhoneSize, MyTextStyle> myTextStyleHeaderBlue = {
  PhoneSize.ipad: MyTextStyle(
      color: Colors.blueAccent, fontWeight: FontWeight.bold, size: 18),
  PhoneSize.iphone: MyTextStyle(
      color: Colors.blueAccent, fontWeight: FontWeight.bold, size: 14),
};

const Map<PhoneSize, MyTextStyle> myTextStyleHeaderYellow = {
  PhoneSize.ipad: MyTextStyle(
      color: Colors.blueGrey, fontWeight: FontWeight.bold, size: 18),
  PhoneSize.iphone: MyTextStyle(
      color: Colors.blueGrey, fontWeight: FontWeight.bold, size: 14),
};

const Map<PhoneSize, MyTextStyle> myTextStyleHeaderGreen = {
  PhoneSize.ipad:
      MyTextStyle(color: Colors.green, fontWeight: FontWeight.bold, size: 18),
  PhoneSize.iphone:
      MyTextStyle(color: Colors.green, fontWeight: FontWeight.bold, size: 14),
};

const Map<PhoneSize, MyTextStyle> myTextStyleHeaderGreenItalic = {
  PhoneSize.ipad: MyTextStyle(
      color: Colors.green,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.italic,
      size: 18),
  PhoneSize.iphone: MyTextStyle(
      color: Colors.green,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.italic,
      size: 14),
};
