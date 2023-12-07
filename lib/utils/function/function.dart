// ignore_for_file: body_might_complete_normally_catch_error

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:school/config/url.dart';

void tracking(String action) async {
  try {
    var response = await Dio(BaseOptions(headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    })).post('$baseUrlSchool' + 'api/tracking', data: {'name': action});
    debugPrint("Tracking : ${response.statusCode}");
  } catch (value) {
    debugPrint("You have been on catch [ Tracking ] $value");
  }
}
