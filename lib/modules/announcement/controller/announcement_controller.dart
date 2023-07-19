import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/config/url.dart';

import '../../../screens/widgets/exceptions.dart';
import '../models/announcment_model.dart';

class AnnouncementController extends GetxController {
  final recAnnouncementList = <Datum>[].obs;
  final isFirstLoading = true.obs;
  final isMoreLoading = true.obs;
  final empty = 0.obs;
  Future fetchAnnouncement({String pageNo = '1'}) async {
    Map<String, String> parameters = {
      'page': pageNo,
    };
    try {
      String fullUrl = '$baseUrlSchool' + 'api/getannouncementlist';
      await Dio(BaseOptions(
        receiveDataWhenStatusError: true,
        connectTimeout: 15000,
        receiveTimeout: 15000,
      )).get(fullUrl, queryParameters: parameters).then((value) {
        AnnouncementDb announcementListDb = AnnouncementDb.fromMap(value.data);
        return announcementListDb;
      });
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      return errorMessage;
    }
  }

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
