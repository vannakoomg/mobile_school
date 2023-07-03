import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:school/modules/gallary/models/gallary_detail_model.dart';
import 'package:school/modules/gallary/models/gallary_model.dart';

import '../../../screens/widgets/exceptions.dart';

class GallaryController extends GetxController {
  final islist = false.obs;

  final oldColor = 0.obs;
  final tagId = ''.obs;
  final urlImage = ''.obs;
  final gallary = GallaryModel().obs;
  final gallaryDetail = GallaryDetailModel().obs;
  final isloading = true.obs;
  final isloadingGallaryDetail = true.obs;

  void getGallary() async {
    try {
      isloading.value = true;
      var response = await Dio(BaseOptions(headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      })).get('http://10.0.2.2:8000/api/gallary');
      gallary.value = GallaryModel.fromJson(response.data);
      isloading.value = false;
      debugPrint("value ${gallary.value.data![0].id}");
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      isloading.value = false;
      debugPrint("you have been catched $errorMessage");
    }
  }

  void getGallaryDetail(String id) async {
    try {
      isloadingGallaryDetail.value = true;
      var response = await Dio(BaseOptions(headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      })).get('http://10.0.2.2:8000/api/gallary?id=$id');
      gallaryDetail.value = GallaryDetailModel.fromJson(response.data);
      isloadingGallaryDetail.value = false;
      debugPrint("value ${gallaryDetail.value.data![0].image}");
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      isloadingGallaryDetail.value = false;
      debugPrint("you have been catched $errorMessage");
    }
  }

  Color getColor() {
    int i = Random().nextInt(8);
    if (oldColor.value == i) {
      i = Random().nextInt(8);
      if (oldColor.value == i) {
        i = Random().nextInt(8);
      }
    }
    oldColor.value = i;
    if (i == 0) {
      return Color(0xff012a4a);
    }
    if (i == 1) {
      return Color(0xffa3cef1);
    }
    if (i == 2) {
      return Color(0xffef476f);
    }
    if (i == 3) {
      return Color(0xffd5896f);
    }
    if (i == 4) {
      return Color(0xff48cae4);
    }
    if (i == 5) {
      return Color(0xffffafcc);
    }
    if (i == 6) {
      return Color(0xff70a288);
    }
    if (i == 7) {
      return Color(0xff2c7da0);
    }
    return Color(0xff2c7da0);
  }
}
