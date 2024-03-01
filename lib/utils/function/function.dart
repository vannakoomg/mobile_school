// ignore_for_file: body_might_complete_normally_catch_error

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:school/config/url.dart';
import 'package:school/repos/aba.dart';

void tracking(
    {String? menuName = '', String campus = '', String userName = ""}) async {
  try {
    debugPrint("menuname:$menuName\nusername:$userName\ncampus:$campus");
    if (userName == "") {
      debugPrint("we do not trick ");
    } else {
      var response = await Dio(BaseOptions(headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': storage.read('user_token'),
      })).post(
        '$baseUrlSchool' + 'api/tracking',
        data: {
          'menu_name': menuName,
          'user_name': userName,
          'campus': campus,
        },
      );
      // debugPrint("Tracking : ${response.data}");
    }
  } catch (value) {
    debugPrint("You have been on catch [ Tracking ] $value");
  }
}

void disablescreenShot() async {
  // if (Platform.isAndroid) {
  //   await ScreenProtector.preventScreenshotOn();
  // } else {
  //   await ScreenProtector.preventScreenshotOn();
  // }
}

void ablescreenShot() async {
  // if (Platform.isAndroid) {
  // } else {
  //   await ScreenProtector.preventScreenshotOff();
  // }
  // await ScreenProtector.preventScreenshotOff();
}
