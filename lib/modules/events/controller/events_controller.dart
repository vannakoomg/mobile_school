import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:school/modules/events/models/event_model.dart';
import 'package:school/screens/widgets/exceptions.dart';

class EventsController extends GetxController {
  final eventDate = EventModel().obs;
  final focusDate = DateTime(2023 - 06 - 01).obs;
  final isloading = true.obs;
  Future<void> getEvent(String startDate) async {
    eventDate.value = EventModel();
    isloading.value = true;
    var response;
    try {
      response = await Dio(BaseOptions(headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      })).get('http://10.0.2.2:8000/api/events?start=$startDate');
      isloading.value = false;
      eventDate.value = EventModel.fromJson(response.data);
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      isloading.value = false;
      debugPrint("you have been catched $errorMessage");
    }
  }
}

class DateUtil {
  static const DATE_FORMAT = 'yyyy/MM/dd';
  String formattedDate(DateTime dateTime) {
    return DateFormat(DATE_FORMAT).format(dateTime);
  }
}
