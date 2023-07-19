import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/config/url.dart';

class AnnouncementController extends GetxController {
  void countAnnouncement(int id) async {
    try {
      var response = await Dio(BaseOptions(headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      })).post('$baseUrlSchool' + 'api/announcemen/create', data: {'id': id});
      debugPrint("countAnnouncement statusCode : ${response.statusCode}");
    } catch (value) {
      debugPrint("you have catch $value");
    }
  }
}
