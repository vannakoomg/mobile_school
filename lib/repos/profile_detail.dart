import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/models/ProfileDB.dart';
import 'package:school/config/url.dart';
import 'package:dio/dio.dart';
import 'package:school/modules/canteen/controller/canteen_controller.dart';
import '../screens/widgets/exceptions.dart';

Future fetchProfile({required String apiKey}) async {
  final canteenController = Get.put(CanteenController());
  try {
    String fullUrl = baseUrlSchool + getProfile;
    var response = await Dio(BaseOptions(headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $apiKey"
    })).get(fullUrl);
    ProfileDb profileDb = ProfileDb.fromMap(response.data);
    canteenController.isMuteCanteen.value =
        profileDb.data.data[0].muteCanteen ?? 0;
    return profileDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
