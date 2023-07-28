// ignore_for_file: unnecessary_null_comparison

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/config/url.dart';
import 'package:school/modules/gallary/models/gallary_detail_model.dart';
import 'package:school/modules/gallary/models/gallary_model.dart';

import '../../../screens/widgets/exceptions.dart';
import '../../../utils/function/function.dart';

class GallaryController extends GetxController {
  final listImage = [
    "https://upload.wikimedia.org/wikipedia/commons/thumb/7/73/Tent_camping_along_the_Sulayr_trail_in_La_Taha%2C_Sierra_Nevada_National_Park_%28DSCF5147%29.jpg/1200px-Tent_camping_along_the_Sulayr_trail_in_La_Taha%2C_Sierra_Nevada_National_Park_%28DSCF5147%29.jpg",
    "https://cdn.outsideonline.com/wp-content/uploads/2021/06/15/camping_fun_s.jpg",
    "https://media.timeout.com/images/105658195/image.jpg",
    "https://v8v7e2w9.stackpathcdn.com/getmedia/f2b92ba3-169b-4816-b055-84f3272d2040/Hero_379.jpg",
    "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/925dac00-20b0-4202-a371-1334fc785846/d9zgg8y-1b2c8265-a498-4549-8d0b-28a2f6e94fdb.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcLzkyNWRhYzAwLTIwYjAtNDIwMi1hMzcxLTEzMzRmYzc4NTg0NlwvZDl6Z2c4eS0xYjJjODI2NS1hNDk4LTQ1NDktOGQwYi0yOGEyZjZlOTRmZGIucG5nIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.NbeRd3vPCUtBKI6k1QqDbbhH9_luhkWmvRK6UFk3ZlE",
    "https://cdn-icons-png.flaticon.com/512/909/909119.png",
    "https://stickershop.line-scdn.net/stickershop/v1/product/4178848/LINEStorePC/main.png",
    "https://www.silhouette.pics/images/quotes/english/general/my-talking-tom-silhouette-52650-172941.jpg",
  ].obs;
  final scrllcontroller = ScrollController().obs;
  final islist = false.obs;
  final oldColor = 0.obs;
  final tagId = ''.obs;
  final urlImage = ''.obs;
  final gallary = GallaryModel().obs;
  final gallaryDetail = GallaryDetailModel().obs;
  final isloading = true.obs;
  final isloadingGallaryDetail = true.obs;
  final isTapImage = false.obs;
  final isTapSave = false.obs;
  final isviewImageDetile = false.obs;
  void getGallary() async {
    try {
      isloading.value = true;
      var response = await Dio(BaseOptions(headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      })).get('${baseUrlSchool}api/gallary');
      gallary.value = GallaryModel.fromJson(response.data);

      isloading.value = false;
      debugPrint("value ${gallary.value.data}");
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
      })).get('${baseUrlSchool}api/gallary?id=$id');
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
    highList.add(high);
    return high;
  }

  void saveThisPhoto() {
    isTapSave.value = !isTapSave.value;
    downloadImage(
      url: "${gallaryDetail.value.data![int.parse(tagId.value)].image}",
    ).then((value) {
      Get.snackbar(
        '',
        '',
        duration: Duration(milliseconds: 1000),
        messageText: Text(
          "Photo Saved",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        borderRadius: 60,
        backgroundColor: Colors.blue,
        padding: EdgeInsets.only(bottom: 22, left: 20),
        snackPosition: SnackPosition.TOP,
        maxWidth: 120,
      );
    });
  }

  Future<void> saveAllPhoto() async {
    isTapSave.value = isTapSave.value;
    for (int i = 0; i < gallaryDetail.value.data!.length; ++i) {
      downloadImage(url: "${gallaryDetail.value.data![i].image}");
    }
  }
}
