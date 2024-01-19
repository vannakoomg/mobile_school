// ignore_for_file: unnecessary_null_comparison

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:school/config/url.dart';
import 'package:school/modules/gallary/models/gallary_detail_model.dart';
import 'package:school/modules/gallary/models/gallary_model.dart';
import 'package:sizer/sizer.dart';

import '../../../screens/widgets/exceptions.dart';

class GallaryController extends GetxController {
  final scrllcontroller = ScrollController().obs;
  final islist = false.obs;
  final oldColor = 0.obs;
  final tagId = ''.obs;
  final urlImage = ''.obs;
  final flex01 = [].obs;
  final flex02 = [].obs;
  final hight = [].obs;
  final gallary = GallaryModel().obs;
  final gallaryDetail = GallaryDetailModel().obs;
  final gallaryData = <ImageModel>[].obs;
  final gallaryDataView = <ImageModel>[].obs;
  final isloading = true.obs;
  final isloadingGallaryDetail = true.obs;
  final isTapImage = false.obs;
  final isTapSave = false.obs;
  final isviewImageDetile = false.obs;
  final nextPage = 0.obs;
  final currentPage = 1.obs;
  // final textKey = GlobalKey();
  final hightOfDescrition = 0.0.obs;
  Future getGallary() async {
    try {
      isloading.value = true;
      var response = await Dio(BaseOptions(headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      })).get('${baseUrlSchool}api/gallary');
      gallary.value = GallaryModel.fromJson(response.data);
      isloading.value = false;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      isloading.value = false;
      debugPrint("you have been catched $errorMessage");
    }
  }

  Future getGallaryDetail({required String id, int page = 1}) async {
    try {
      isloadingGallaryDetail.value = true;
      var response = await Dio(BaseOptions(headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      })).get('${baseUrlSchool}api/gallary?id=$id&page=$page');
      gallaryDetail.value = GallaryDetailModel();
      gallaryDetail.value = GallaryDetailModel.fromJson(response.data);
      for (int i = 0; i < gallaryDetail.value.data!.length; ++i) {
        flex01.add(Random().nextInt(3) + 2);
        flex02.add(Random().nextInt(3) + 2);
        hight.add(getHigh());
        gallaryData.add(gallaryDetail.value.data![i]);
      }
      if (gallaryDetail.value.data!.length.floor().isOdd) {
        gallaryData.add(ImageModel(image: ""));
      }
      isloadingGallaryDetail.value = false;
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
      return Color.fromARGB(255, 240, 207, 99);
    }
    if (i == 1) {
      return Color(0xff219ebc);
    }
    if (i == 2) {
      return Color.fromARGB(255, 238, 107, 137);
    }
    if (i == 3) {
      return Color.fromARGB(255, 239, 171, 148);
    }
    if (i == 4) {
      return Color.fromARGB(255, 111, 222, 244);
    }
    if (i == 5) {
      return Color.fromARGB(255, 248, 174, 89);
    }
    if (i == 6) {
      return Color.fromARGB(255, 135, 240, 186);
    }
    if (i == 7) {
      return Color.fromARGB(255, 236, 95, 104);
    }
    return Color.fromARGB(255, 10, 162, 227);
  }

  final highList = [].obs;
  double getHigh() {
    int i = Random().nextInt(4);
    double high = 0.0;
    if (i == 0) {
      high = 300;
    }
    if (i == 1) {
      high = 150;
    }
    if (i == 2) {
      high = 180;
    }
    if (i == 3) {
      high = 220;
    }
    if (SizerUtil.deviceType == DeviceType.tablet) {
      high = 1.5 * high;
    }
    highList.add(high);
    return high;
  }

  final imageSave = 0.obs;
  final saveDone = false.obs;
  Future<void> saveAllPhoto() async {
    isTapSave.value = false;
    saveDone.value = false;
    for (int i = 0; i < gallaryDetail.value.data!.length; ++i) {
      await GallerySaver.saveImage("${gallaryDetail.value.data![i].image}");
      imageSave.value = imageSave.value + 1;
    }
    saveDone.value = true;
    Future.delayed(const Duration(milliseconds: 1200), () {
      imageSave.value = 0;
    });
  }

  Future<void> saveThisPhoto() async {
    isTapSave.value = false;
    saveDone.value = false;
    imageSave.value = 1;
    await GallerySaver.saveImage("${urlImage.value}");
    saveDone.value = true;
    Future.delayed(const Duration(milliseconds: 1200), () {
      imageSave.value = 0;
    });
  }
}
